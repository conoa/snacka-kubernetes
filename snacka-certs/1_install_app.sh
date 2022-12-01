#!/bin/bash

# Set default namespace in kubectl
kubectl config set-context --current --namespace=ingress-basic

kubectl delete -n ingress-basic -f ~/src/snacka-kubernetes-certs/manifests/kuard.yaml

kubectl get svc -l app=kuard -n=ingress-basic
kubectl get deployment -l app=kuard  -n ingress-basic 

# Install the app kuard in kubernetes
kubectl apply -n ingress-basic -f ~/src/snacka-kubernetes-certs/manifests/kuard.yaml
kubectl get po -l app=kuard -n=ingress-basic

kubectl apply -n ingress-basic -f ~/src/snacka-kubernetes-certs/manifests/minimal-ingress.yaml

# 1. Install cert-1
./scripts/create_self_signed_cert_1.sh

# Check cert.

# chrome 
# https://ijoijoi123.com/
# NET::ERR_CERT_AUTHORITY_INVALID
# F12, Cert info.
openssl x509 -noout -text -in ~/src/snacka-kubernetes-certs/scripts/cert-1/tls.crt
curl -kv https://ijoijoi123.com/ 
openssl s_client -connect ijoijoi123.com:443 -servername ijoijoi123.com
# Add to trusted root certificates of chrome
# Check cert.

# 2. Install cert-2
./scripts/create_self_signed_cert_2.sh

openssl x509 -noout -text -in ~/src/snacka-kubernetes-certs/scripts/cert-2/tls.crt

# Check cert.

# chrome
# https://ijoijoi123-2.com/
# NET::ERR_INVALID_NAME
curl -kv https://ijoijoi123.com/ 
openssl s_client -connect ijoijoi123.com:443 -servername ijoijoi123.com

# Error 1. mispelled secret name
# 
kubectl apply -n ingress-basic -f ~/src/snacka-kubernetes-certs/manifests/minimal-ingress-bad1.yaml
# Kubernetes Ingress Controller Fake Certificate
openssl s_client -connect ijoijoi123.com:443 -servername ijoijoi123.com
# Check error...
kubectl logs -n ingress-basic -l app.kubernetes.io/name=ingress-nginx

#
# Error 2. bad secret filename
#
cp ~/src/snacka-kubernetes-certs/scripts/cert-2/tls.crt /tmp/tls.pem
# Create a secret in kubernetes
kubectl delete secret -n ingress-basic tls-secret
kubectl create secret tls tls-secret \
    --key ~/src/snacka-kubernetes-certs/scripts/cert-2/tls.key \
    --cert /tmp/tls.pem \
    -n ingress-basic
kubectl get secret -n ingress-basic tls-secret -o yaml
kubectl delete po  -n ingress-basic -l app.kubernetes.io/name=ingress-nginx --force --grace-period=0

curl -kv https://ijoijoi123.com/
kubectl logs -n ingress-basic -l app.kubernetes.io/name=ingress-nginx

# Ingress TLS certificate example from 
# https://github.com/kubernetes/ingress-nginx/tree/e9c297e74dd20601a7bec89b86d36e75d323c5ce/docs/examples/tls-termination

# Troubleshoot online tools
https://www.ssllabs.com/ssltest/analyze.html?d=ijoijoi123.com&ignoreMismatch=on&latest

# Bra sida
https://thecyphere.com/blog/pki-explained/

