defmodule MockServerWeb.RouteController do
  use MockServerWeb, :controller
  import Destructure

  alias MockServer.Servers

  def create(conn, params) do
    {:ok, route} = Servers.add_route(params["server_id"], params)
    conn
    |> put_status(:created)
    |> render("route.json", d%{route})
  end

  def index(conn, params) do
  end
end
