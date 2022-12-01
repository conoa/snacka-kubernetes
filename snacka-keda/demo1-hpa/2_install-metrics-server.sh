#!/bin/bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.0/components.yaml

cat > metric-server-patch.yaml <<EOF
spec:
  template:
    spec:
      containers:
      - args:
        - --cert-dir=/tmp
        - --secure-port=443
        - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
        - --kubelet-use-node-status-port
        - --metric-resolution=15s
        - --kubelet-insecure-tls
        name: metrics-server
EOF
kubectl patch deployment metrics-server -n kube-system --patch "$(cat metric-server-patch.yaml)"

# Wait until the metrics-server has started
kubectl get po -n=kube-system -w

kubectl get deploy,svc -n kube-system | egrep metrics-server
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes"|jq
