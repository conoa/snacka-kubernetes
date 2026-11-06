FROM docker.io/nginx:latest AS noos

RUN echo -e 'PRETTY_NAME="Linux"\nNAME="Linux"\nVERSION_ID="99"\nVERSION="99 (asd)"\nID=Linux' > /etc/os-release


FROM docker.io/nginx:latest AS fakeos

RUN echo -e 'NAME="Alpine Linux"\nID=alpine\nVERSION_ID=3.24.4\nPRETTY_NAME="Alpine Linux v3.24"\nHOME_URL="https://alpinelinux.org/"\nBUG_REPORT_URL="https://gitlab.alpinelinux.org/alpine/aports/-/issues"' > /etc/os-release


FROM noos AS nopkg

RUN rm -rf /var/cache/apt/archived
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/lib/dpkg/status
