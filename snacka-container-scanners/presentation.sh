trivy image docker.io/nginx:latest
grype docker.io/nginx:latest

trivy image docker.io/nginx:latest | grep Total:
grype docker.io/nginx:latest > /dev/null
trivy image docker.io/nginx:alpine | grep Total:
grype docker.io/nginx:alpine > /dev/null


grep 'noos$' Dockerfile -A 3
docker build . -t frontend:noos --target noos
trivy image frontend:noos | grep Total:
grype frontend:noos > /dev/null

grep 'fakeos$' Dockerfile -A 3
docker build . -t frontend:fakeos --target fakeos
trivy image frontend:fakeos | grep Total:
grype frontend:fakeos > /dev/null

grep 'nopkg$' Dockerfile -A 4
docker build . -t frontend:nopkg --target nopkg
trivy image frontend:nopkg | grep Total:
grype frontend:nopkg > /dev/null


head -21 Dockerfile
trivy fs frontend/yarn.lock
trivy image docker.io/nginx:alpine

docker build . --target production -t frontend:production
trivy image frontend:production
grype frontend:production

docker build . --target zero -t frontend:zero
trivy image frontend:zero
grype frontend:zero


trivy image --format spdx-json docker.io/nginx:alpine > nginx-sbom.json
jq '.packages[15:17]' < frontend-sbom.json
trivy image --format spdx-json frontend:production > frontend-sbom.json
wc -l *-sbom.json
grep quasar frontend/yarn.lock
grep quasar frontend-sbom.json
