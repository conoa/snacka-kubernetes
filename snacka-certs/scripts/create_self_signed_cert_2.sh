#!/bin/bash

cd ~/src/snacka-kubernetes-certs/scripts
# Create a self signed certificate with Subject Alternative Name (SAN) for the domain name
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout ./cert-2/tls.key \
    -out ./cert-2/tls.crt -subj "/CN=ijoijoi123.com" \
    -addext "subjectAltName=DNS:ijoijoi123.com"        

ls -l ~/src/snacka-kubernetes-certs/scripts/cert-2

openssl x509 -noout -text -in ~/src/snacka-kubernetes-certs/scripts/cert-2/tls.crt
cp ~/src/snacka-kubernetes-certs/scripts/cert-2/tls.crt /mnt/c/Users/marten/Downloads/ijoijoi123-2.com.crt

# Create a secret in kubernetes
kubectl delete secret -n ingress-basic tls-secret
kubectl create secret tls tls-secret \
    --key ~/src/snacka-kubernetes-certs/scripts/cert-2/tls.key \
    --cert ~/src/snacka-kubernetes-certs/scripts/cert-2/tls.crt \
    -n ingress-basic
kubectl get secret -n ingress-basic tls-secret -o yaml
kubectl delete po  -n ingress-basic -l app.kubernetes.io/name=ingress-nginx --force --grace-period=0
