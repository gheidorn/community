FROM elixir:alpine

COPY . .

RUN export MIX_ENV=prod && \
    mix local.hex --force && \
    mix local.rebar --force && \
    rm -Rf _build && \
    mix deps.get --force && \
    mix release