# Kan man lita på containerimagescanning? Extended edition

* https://www.php.net/archive/2026.php#2026-10-21-5
  - CVE-2026-109618 (9.2)
  - CVE-2026-109619 (9.2)
  - patchad i 8.5.12, 8.4.27, 8.3.36 or 8.2.35

Vi kollar på php-image för 8.5.11 - CVE ska finnas

**Skanna Php med Trivy**

kolla på resultaten - kan vi hitta php-cves?

**Skanna med Neuvector**

samma här: finns de?

Kolla på dockerhub:
https://hub.docker.com/layers/library/php/8.5.11/images/sha256-404e264890de8f4fce2efb35d1780c3b90432eca692ae29310fe8083c9212845
finns de där?

kolla på lagren - php kompileras i imagen - inget paket -> trivy kan inte hitta den


nextcloud använder php

**Skanna Nextcloud * 2 med Trivy och Grype**

i det första fallet - utgår från php-imagen -> trivy hittar ej - 15
i det andra fallet - använder ett apk-paket -> trivy hittar - 25

https://hub.docker.com/layers/library/nextcloud/35.0.1/images/sha256-82c26506d8c8ae959ff4fc33c7fc2680a0c50e86ab9bdf99ef178d147d1154f0
https://hub.docker.com/layers/linuxserver/nextcloud/35.0.1/images/sha256-1592fe997f84f0ec9728b660c445421c18d6b3ceef508174665a4858b5943a05

dags att kolla på vilken mjukvara som finns i images - SBOMs

Två huvudsakliga standarder:

SPDX
- Linux foundation 2010
- Designad för att hålla koll på licensdata i Open Source
- Fått stöd för mycket mer
- Senaste: spdx 3.0

CycloneDX
- OWASP 2017
- Designad för supply chain security
  - Sårbarheter
  - Beroenden
  - Integritet
- Senaste CycloneDX 1.7

**SKAPA SBOMs med Trivy**

* titta på filerna
  - CVEs
  - finns PHP?
  
** Skapa SBOM med Syft **

Php finns.

** Skanna SBOM med grype**

Samma resultat som skanning med endast Grype.

** Skanna SBOM med Trivy **

Fortfarande ingen php.
