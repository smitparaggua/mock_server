defmodule MockServer.Servers.Query do
  import Ecto.Query, warn: false

  def from_recently_created(queryable) do
    from v in queryable, order_by: [desc: v.inserted_at]
  end

  def with_path_starting_with(queryable, string) do
    search = "/#{string}%"
    from v in queryable, where: like(v.path, ^search)
  end

  def with_server_id(queryable, server_id) do
    from v in queryable, where: v.server_id == ^server_id
  end

  def with_routes(queryable) do
    from v in queryable, preload: [:routes]
  end
end
