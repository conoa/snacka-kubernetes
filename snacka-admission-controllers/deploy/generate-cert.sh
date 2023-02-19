echo "subjectAltName = DNS:validateme.default.svc" > validate_extfile.cnf
echo "subjectAltName = DNS:mutateme.default.svc" > mutate_extfile.cnf

# Generate the CA cert and private key
openssl req -nodes -new -x509 \
    -keyout ca.key \
    -out ca.crt -subj "/CN=admission-controller-demo"

# Generate the private key for the webhook server
openssl genrsa -out webhook-server-tls.key 2048

# Generate a Certificate Signing Request (CSR) for the private key
# and sign it with the private key of the CA.
# validate
openssl req -new -key webhook-server-tls.key \
    -subj "/CN=admission-controller-demo" \
    | openssl x509 -req -CA ca.crt -CAkey ca.key \
        -CAcreateserial -out validate-webhook-server-tls.crt \
        -extfile validate_extfile.cnf

# mutate
openssl req -new -key webhook-server-tls.key \
    -subj "/CN=admission-controller-demo" \
    | openssl x509 -req -CA ca.crt -CAkey ca.key \
        -CAcreateserial -out mutate-webhook-server-tls.crt \
        -extfile mutate_extfile.cnf