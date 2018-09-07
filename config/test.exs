use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mock_server, MockServerWeb.Endpoint,
  http: [port: 4001],
  server: false

config :mock_server, MockServer.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10,
  database: "mock_server_test"

config :mock_server, initialize_server_processes: false

# Print only warnings and errors during test
config :logger, level: :warn

if (File.exists?(Path.join(__DIR__, "test.secret.exs"))) do
  import_config "test.secret.exs"
end
