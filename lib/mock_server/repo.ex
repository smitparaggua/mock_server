defmodule MockServer.Repo do
  use Ecto.Repo, otp_app: :mock_server, adapter: Sqlite.Ecto2
end
