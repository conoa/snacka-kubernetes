Pod Security Standards
----------------------

Är tänkt att användas i en Rancher Desktop-miljö, annars får man anpassa kommandona.

För att sätta upp miljön:

## Användare (frivilligt)

För att sätta upp en cuser-användare med behörigheter i ns `demo` och `demo-restricted`:
```shell
kubectl apply -f user/cuser-csr.yaml
kubectl certificate approve cuser-request
kubectl config set-credentials cuser --client-key=user/cuser.pem --client-certificate=<((kubectl get csr cuser-request -o jsonpath={"$.status.certificate"} | base64 -d)) --embed-certs
kubectl config set-context cuser --user cuser --cluster rancher-desktop
kubectl apply -f user/ns-demo.yaml
kubectl apply -f user/ns-demo-restricted.yaml
kubectl apply -f user/role.yaml -n demo
kubectl apply -f user/rolebinding-demo.yaml -n demo
kubectl apply -f user/rolebinding-demo-restricted.yaml -n demo-restricted
```

För att aktivera användaren:
```shell
kubectl config use-context cuser
```

## Presentation

Stödord/kommandon finns i script.md.
