A simple mutating/validating admission webhook written in Rust with Axum.

Snacka Kubernetes om Admission Controllers och Rust: https://youtu.be/toFWGvW24Ek

## Build container image
```bash
cargo b --release
BUILD_KIT=1 docker build -t rusty-admission .
```

“Good artists borrow, great artists steal.” - Pablo Picasso

https://kubernetes.io/blog/2019/03/21/a-guide-to-kubernetes-admission-controllers/

https://sysdig.com/blog/kubernetes-admission-controllers/

https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/

https://slack.engineering/simple-kubernetes-webhook/

https://github.com/alex-leonhardt/k8s-mutate-webhook

https://github.com/SachinMaharana/basic-validation-controller

https://medium.com/ovni/writing-a-very-basic-kubernetes-mutating-admission-webhook-398dbbcb63ec

Links about Rust:

https://www.rust-lang.org

https://foundation.rust-lang.org

https://doc.rust-lang.org/book/

https://github.com/rust-lang/rustlings/

https://tokio.rs

https://github.com/tokio-rs/axum
