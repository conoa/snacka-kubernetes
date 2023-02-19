use std::{net::SocketAddr, path::PathBuf};

use kube::{
    core::{
        admission::{AdmissionRequest, AdmissionResponse, AdmissionReview},
        DynamicObject, Status,
    },
    Resource, ResourceExt,
};

use axum::{
    response::Json,
    routing::{get, post},
    Router,
};

use axum_server::tls_rustls::RustlsConfig;
use axum_server::Handle;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt, EnvFilter};

use serde_json::{json, Value};

#[tokio::main]
async fn main() {
    // start tracing
    // read log level from env
    tracing_subscriber::registry()
        .with(tracing_subscriber::fmt::layer())
        .with(EnvFilter::from_env("WEBHOOK_LOG"))
        .init();

    // configure certificate and private key used by https
    let config = RustlsConfig::from_pem_file(
        PathBuf::from("/certs")
            .join("tls.crt"),
        PathBuf::from("/certs")
            .join("tls.key"),
    )
    .await
    .unwrap();

    //
    let app = Router::new()
        .route("/mutate", post(mutate))
        .route("/validate", post(validate))
        .route("/healthz", get(health));

    // register graceful shutdown handle
    let handle = Handle::new();
    tokio::spawn(shutdown_signal(handle.clone()));

    // start server
    let addr = SocketAddr::from(([0, 0, 0, 0], 8443));
    tracing::debug!("listening on {}", addr);
    axum_server::bind_rustls(addr, config)
        .serve(app.into_make_service())
        .await
        .unwrap();
}

async fn health() -> Json<Value> {
    Json(json!("message: ok"))
}

async fn validate(
    axum::extract::Json(body): axum::extract::Json<AdmissionReview<DynamicObject>>,
) -> Json<Value> {
    let req: AdmissionRequest<_> = body.try_into().unwrap();

    let mut resp = AdmissionResponse::from(&req);
    resp.allowed = true;

    // req.Object always exists for us, but could be None if extending to DELETE events
    let obj = req.object.unwrap();

    if !obj.labels().contains_key("conoa") {
        resp.allowed = false;
        resp.result = Status {
            message: format!(r#"labels must contain conoa"#), // err ca 120 char
            ..Default::default()
        };
    }

    return Json(json!(resp.into_review()));
}

async fn mutate(
    axum::extract::Json(body): axum::extract::Json<AdmissionReview<DynamicObject>>,
) -> Json<Value> {
    let req: AdmissionRequest<_> = body.try_into().unwrap();

    let resp = AdmissionResponse::from(&req);

    // req.Object always exists for us, but could be None if extending to DELETE events
    let obj = req.object.unwrap();

    if !obj.labels().contains_key("conoa") {
        let mut patches = Vec::new();

        // Ensure labels exist before adding a key to it
        if obj.meta().labels.is_none() {
            patches.push(json_patch::PatchOperation::Add(json_patch::AddOperation {
                path: "/metadata/labels".into(),
                value: serde_json::json!({}),
            }));
        }
        // Add our label
        patches.push(json_patch::PatchOperation::Add(json_patch::AddOperation {
            path: "/metadata/labels/conoa".into(),
            value: serde_json::Value::String(r#"snacka-kubernetes"#.into()),
        }));

        return Json(json!(resp
            .with_patch(json_patch::Patch(patches))
            .unwrap()
            .into_review()));
    }
    Json(json!(resp.into_review()))
}

// graceful shutdown
async fn shutdown_signal(handle: Handle) {
    handle.graceful_shutdown(Some(std::time::Duration::from_secs(30)));
}

/// axum handler for any request that fails to match the router routes.
/// This implementation returns HTTP status code Not Found (404).
pub async fn fallback(uri: axum::http::Uri) -> impl axum::response::IntoResponse {
    (
        axum::http::StatusCode::NOT_FOUND,
        format!("No route {}", uri),
    )
}
