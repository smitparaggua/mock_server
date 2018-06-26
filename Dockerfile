FROM elixir:1.6.5-alpine
RUN mix local.hex --force && mix local.rebar --force

RUN apk add --update --no-cache nodejs nodejs-npm inotify-tools

COPY ./mix.exs /src/
COPY ./mix.lock /src/
WORKDIR /src
RUN mix deps.get
RUN mix deps.compile

COPY ./assets /src/assets/
WORKDIR /src/assets
RUN npm install

COPY ./config /src/config/
COPY ./lib /src/lib/
COPY ./priv /src/priv/
COPY ./test /src/test/
COPY ./.iex.exs /src/

WORKDIR /src
CMD mix phx.server