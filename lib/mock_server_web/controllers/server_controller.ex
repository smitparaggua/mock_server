defmodule MockServerWeb.ServerController do
  use MockServerWeb, :controller
  alias MockServer.Servers
  import Destructure

  def create(conn, params) do
    {:ok, server} = Servers.create(params)
    conn
    |> put_status(:created)
    |> render("server.json", d(%{server}))
  end

  def show(conn, %{"id" => id}) do
    server = Servers.get(id)
    render(conn, "server.json", d(%{server}))
  end

  def index(conn, _params) do
    servers = Servers.list()
    render(conn, "servers.json", %{servers: servers})
  end
end
