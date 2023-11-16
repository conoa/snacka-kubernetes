FROM docker.io/node:18-alpine AS build

RUN yarn global add @quasar/cli

COPY ./frontend/package.json /package.json
COPY ./frontend/yarn.lock /yarn.lock
WORKDIR /
RUN yarn install

COPY ./frontend /code
RUN mv /node_modules /code/
WORKDIR /code

RUN quasar build


FROM docker.io/nginx:alpine AS production

COPY --from=build /code/dist/spa/ /usr/share/nginx/html/
COPY ./frontend/nginx.conf /etc/nginx/nginx.conf


FROM docker.io/nginx:latest AS noos

RUN echo -e 'PRETTY_NAME="Linux"\nNAME="Linux"\nVERSION_ID="99"\nVERSION="99 (asd)"\nID=Linux' > /etc/os-release


FROM docker.io/nginx:latest AS fakeos

RUN echo -e 'NAME="Alpine Linux"\nID=alpine\nVERSION_ID=3.18.3\nPRETTY_NAME="Alpine Linux v3.18"\nHOME_URL="https://alpinelinux.org/"\nBUG_REPORT_URL="https://gitlab.alpinelinux.org/alpine/aports/-/issues"' > /etc/os-release


FROM noos AS nopkg

RUN rm -rf /var/cache/apt/archived
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/lib/dpkg/status
