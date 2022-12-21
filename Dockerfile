FROM ghcr.io/h3poteto/elixir-rust-node:1.12.3-rust1.58-node16-slim-buster

USER root

ADD . /var/opt/app
WORKDIR /var/opt/app

RUN chown -R elixir:elixir /var/opt/app

USER elixir
ENV MIX_ENV=prod
ARG SECRET_KEY_BASE

RUN set -ex && \
    mix local.hex --force && \
    mix deps.get && \
    mix local.rebar --force && \
    mix deps.compile && \
    mix compile

RUN set -ex && \
    cd assets && \
    npm install && \
    npm run deploy && \
    rm -rf node_modules


RUN set -ex && \
    mix phx.digest

CMD mix phx.server
