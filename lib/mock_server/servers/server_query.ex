defmodule MockServer.Servers.Query do
  import Ecto.Query, warn: false

  def from_recently_created(queryable) do
    from v in queryable, order_by: [desc: v.inserted_at]
  end

end
