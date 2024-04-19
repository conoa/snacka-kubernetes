* `kubectl apply -f 0_root_helper.yaml`
* `kubectl exec -it nsenter --mount=/proc/1/ns/mnt -- bash`

---

* varför pss
* vad är container

---

* börja - container
* `host: ps aux | grep "sleep 36000"`
* `cat ubuntu.yaml`
* `kubectl apply -f ubuntu.yaml`
* `kubectl exec -it ubuntu -- bash`
* `ps aux # pid`
* host: `ps aux | grep "sleep 36000" # pid`
* host: `kill -9 (pid)`
* `kubectl get pods # error`
* restart -> host: `ps aux | grep "sleep 36000"`
* host: `lsns` # typer
* sätts upp av container runtime

---

* vad är pss - https://kubernetes.io/docs/concepts/security/pod-security-standards/
* privileged 
  - default i vanilla 
  - starta vad som helst
* default i k8s -> användbar, ej säkerhet
* regler för att skydda klustret -> pss
* baseline
* begränsad användare - endast * poddar i ns demo
* `kubectl auth can-i --list`

---

* hostProcess - Windows

---

* host namespaces - få använda hostens t ex pidnamespace
* `cat ubuntu-hostpid.yaml`
* `kubectl apply -f ubuntu-hostpid.yaml`
* `kubectl exec -it ubuntu-hostpid -- bash`
* `ps aux`
* root: `ps aux`
* `ps aux|grep 36000`
* `kill -9 1695`
* `kubectl get pods # ubuntupodens ps dödad`
* kan göra betydligt mer maligna saker
* `nsenter --mount=/proc/1/ns/mnt -- bash`  # permission denied - återkommer
* `kubectl delete -f ubuntu-hostpid.yaml`

---

* privileged
* `cat ubuntu-priv.yaml`
* `kubectl apply -f ubuntu-priv.yaml  # privileged + hostpid`
* `kubectl exec -it ubuntu-priv -- bash`
* `nsenter --mount=/proc/1/ns/mnt -- bash`  # host!
* `cat /etc/rancher/k3s/k3s.yaml`
* kopiera till fil: emacs kube ...
* `kubectl get all -A --kubeconfig=kube ` # admin på klustret, oops
* `kubectl delete -f ubuntu-priv.yaml`
* ovanstående = hostterminal

---

* capabilities
* kan styra vad man får göra
* `kubectl exec -it ubuntu -- bash  # root`
* `apt update && apt install iptables -y`
* `iptables -L`  # must be root?!
* https://man7.org/linux/man-pages/man7/capabilities.7.html
* `cat ubuntu-iptables.yaml`
* `kubectl apply -f ubuntu-iptables.yaml`
* `kubectl exec -it ubuntu-iptables -- bash`
* `apt update && apt install iptables -y`
* `iptables -L `# works
* `kubectl delete -f ubuntu-iptables.yaml`
* `kubectl delete -f ubuntu.yaml`

---

* hostpath
* `cat ubuntu-hostpath.yaml`
* `kubectl apply -f ubuntu-hostpath.yaml`
* `kubectl exec -it ubuntu-hostpath -- bash`
* `cat /host/etc/rancher/k3s/k3s.yaml`  # admin på kluster
* `kubectl delete -f ubuntu-hostpath.yaml`

---

* hostport - använda port på host - ingen demo

---

* apparmor/selinux - whitelistning av vad man får göra - inte stöd för det i min uppsättning - ej stänga av

---

* /proc - ej stänga av maskning - lite som hostpid mm

---

* seccomp - begränsa syscalls - ej stänga av

---

* sysctl - begränsa - endast påverka ett namespace

---

* klar med baseline: påverkar ej "vanlig" användning

---

* restricted - best practice - mer invasiv
* mer "security in depth"

---

* volymtyper

---

* privilege escalation - setuid/setgid etc

---

* nonroot
* `cat ubuntu-nonroot.yaml`
* `kubectl apply -f ubuntu-nonroot.yaml`
* `kubectl exec -it ubuntu-nonroot -- bash`
* `cat /host/etc/rancher/k3s/k3s.yaml # denied`
* `kubectl delete -f ubuntu-nonroot.yaml`

---

* seccomp - måste vara aktivt

---

* capabilities - stoppa alla, `NET_BIND_SERVICE` ok: privileged ports (<1024): docker tillåter by default

---

* psa - https://kubernetes.io/docs/concepts/security/pod-security-admission/
* namespace:
* `pod-security.kubernetes.io/<MODE>: <LEVEL>`
* `pod-security.kubernetes.io/<MODE>-version: <VERSION>`
* admission controller ("globalt"): https://kubernetes.io/docs/tasks/configure-pod-container/enforce-standards-admission-controller/
* allt eller inget
* färdiga regler i kyverno - välja

---

* `kubectl get ns demo-restricted --show-labels`
* `kubectl apply -f ubuntu-priv.yaml -n demo-restricted`
* `cat nginx.yaml`
* `kubectl apply -f nginx.yaml -n demo-restricted  # fail`
* `cat nginx-restricted.yaml`
* `kubectl apply -f nginx-restricted.yaml -n demo-restricted  # fail`

---

* allt säkert
* kubernetes - komplext
* RBAC...
* `kubectl auth can-i --list -n demo-restricted  # *...`
* göra vad jag vill i namespacet
* `kubectl label ns demo-restricted pod-security.kubernetes.io/enforce-`
* `kubectl apply -f ubuntu-priv.yaml -n demo-restricted`
* `kubectl get pods -n demo-restricted`  # oops...

---

* kubernetes är komplext
* lätt att göra misstag
* defence in depth
* aktivera PSS för att få flera lager som kan fånga upp misstag
* behöver fortfarande hålla koll
