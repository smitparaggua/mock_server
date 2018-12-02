# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :mock_server, MockServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qDwZwTgkQGvywF2Lu7tOVdKXzFyjhd0M4Ar4CIlEEwk2D4zC6D0/gWz0W6+b9+Jo",
  render_errors: [view: MockServerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MockServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :mock_server,
  ecto_repos: [MockServer.Repo],
  initialize_server_processes: true

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
