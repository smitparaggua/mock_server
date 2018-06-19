defmodule MockServer.Repo do
  use Ecto.Repo,
    otp_app: :mock_server,
    adapter: Ecto.Adapters.Postgres
end
