FROM elixir:1.18-alpine as build

RUN apk add --no-cache git

RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /app

COPY mix.exs mix.lock ./
RUN mix deps.get

COPY . .

RUN mix deps.compile
RUN mix compile

EXPOSE 4000

CMD ["mix", "phx.server"]
