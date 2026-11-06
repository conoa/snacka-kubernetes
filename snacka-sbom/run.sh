trivy image php:8.5.11 > php-trivy.txt
less php-trivy.txt
trivy image dhi.io/php:8.5.11 > php-dhi-trivy.txt
less php-dhi-trivy.txt

docker run --name neuvector.scanner --rm -e SCANNER_REPOSITORY=dhi.io/php -e SCANNER_TAG=8.5.11 -e SCANNER_ON_DEMAND=true -v /var/run/docker.sock:/var/run/docker.sock -v /var/neuvector:/var/neuvector  neuvector/scanner > php-dhi-nv.txt
less php-dhi-nv.txt

grype php:8.5.11
grype dhi.io/php:8.5.11

trivy image nextcloud:35.0.1 > nc-orig-trivy.txt
less nc-orig-trivy.txt
trivy image linuxserver/nextcloud:35.0.1 > nc-trivy.txt
less nc-trivy.txt

grype nextcloud:35.0.1 > nc-orig-grype.txt
less nc-orig-grype.txt
grype linuxserver/nextcloud:35.0.1 > nc-grype.txt
less nc-grype.txt

trivy image dhi.io/php:8.5.11 --format cyclonedx --scanners vuln -o php-cdx.json
trivy image dhi.io/php:8.5.11 --format spdx-json --scanners vuln -o php-spdx.json
emacs php-cdx.json php-spdx.json

syft scan dhi.io/php:8.5.11 --output cyclonedx-json=php-syft-raw.cdx && jq < php-syft-raw.cdx > php-syft.cdx
less php-syft.cdx
grype php-syft.cdx
trivy sbom php-syft.cdx > php-trivy-sbom.txt
less php-trivy-sbom.txt

cd build
docker build -t req-test .
trivy image req-test > req-test-trivy.txt
less req-test-trivy.txt
grype req-test > req-test-grype.txt
less req-test-grype.txt
cd ..

cd multi-stage
less Dockerfile

docker build . -t multi-production --target production
trivy image multi-production > prod-trivy.txt
less prod-trivy.txt

docker build . -t multi-pkg --target pkg
trivy image multi-pkg > pkg-trivy.txt
less pkg-trivy.txt

trivy image multi-production --format cyclonedx --scanners vuln > multi-prod.cdx
trivy image multi-pkg --format cyclonedx --scanners vuln > multi-pkg.cdx
cyclonedx merge --input-files multi-pkg.cdx multi-prod.cdx --output-file multi.cdx --output-format json --input-format json

trivy sbom multi.cdx > multi-trivy.txt
less multi-trivy.txt
cd ..

cd extra
trivy image nginx > nginx-trivy.txt
less nginx-trivy.txt
grype nginx > nginx-grype.txt
less nginx-grype.txt

less Dockerfile

docker build . -t extra:noos --target noos
trivy image extra:noos > nginx-trivy-noos.txt
less nginx-trivy-noos.txt
grype extra:noos > nginx-grype-noos.txt
less nginx-grype-noos.txt

docker build . -t extra:fakeos --target fakeos
trivy image extra:fakeos > nginx-trivy-fakeos.txt
less nginx-trivy-fakeos.txt
grype extra:fakeos > nginx-grype-fakeos.txt
less nginx-grype-fakeos.txt

docker build . -t extra:nopkg --target nopkg
trivy image extra:nopkg > nginx-trivy-nopkg.txt
less nginx-trivy-nopkg.txt
grype extra:nopkg > nginx-grype-nopkg.txt
less nginx-grype-nopkg.txt
cd ..

