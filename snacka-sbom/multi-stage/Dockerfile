FROM node:22-alpine AS base

RUN yarn global add @quasar/cli

COPY ./package.json /package.json
COPY ./yarn.lock /yarn.lock
WORKDIR /
RUN yarn install

COPY ./ /code
RUN mv /node_modules /code/
WORKDIR /code

FROM base AS build

ARG version
ENV VERSION=$version

RUN quasar build

FROM nginxinc/nginx-unprivileged:latest AS production

USER root
RUN apt update && apt upgrade -y

COPY --from=build /code/dist/spa/ /usr/share/nginx/html/
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

USER nginx

EXPOSE 8080

FROM scratch AS pkg
COPY --from=build /package.json /package.json
COPY --from=build /yarn.lock /yarn.lock
COPY --from=build /code/node_modules /node_modules
