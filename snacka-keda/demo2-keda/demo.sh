#!/bin/bash

# kind
kind create cluster

# 1. keda
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
kubectl create namespace keda
helm install keda kedacore/keda --namespace keda
kubectl get po  -n=keda -w

# 2. rabbitmq
# kubectl delete pvc --all --force --wait=false
#helm uninstall rabbitmq
helm repo update;
helm repo add bitnami https://charts.bitnami.com/bitnami;
helm install rabbitmq --set auth.username=marten --set auth.password=P@ssw0rd12345 --set volumePermissions.enabled=true bitnami/rabbitmq --wait
# Wait until rabbitmq is started

# wait for rabbitmq to deploy
kubectl get deploy
kubectl get po # 0
# Deploy consumer
kubectl apply -f deploy/3-deploy-consumer.yaml
# Start publisher
kubectl apply -f deploy/4-deploy-publisher.yaml

# validate consumer is running
kubectl get deploy
# validate scaling
kubectl get deploy -w
kubectl get hpa
