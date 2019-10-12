FROM node:10-alpine AS assets

COPY ./assets /var/opt/app/assets
COPY ./priv /var/opt/app/priv
WORKDIR /var/opt/app/assets

RUN set -ex && \
    npm install && \
    npm run deploy && \
    rm -rf node_modules


FROM h3poteto/elixir-rust:1.8.2-rust1.38-slim-stretch

ADD . /var/opt/app
WORKDIR /var/opt/app

RUN set -ex && \
    mix local.hex --force && \
    mix deps.get && \
    mix local.rebar --force && \
    mix deps.compile && \
    mix compile

USER root

COPY --from=assets /var/opt/app/priv/static /var/opt/app/priv/static
RUN chown -R elixir:elixir /var/opt/app

USER elixir

RUN set -ex && \
    mix phx.digest

CMD mix phx.server
