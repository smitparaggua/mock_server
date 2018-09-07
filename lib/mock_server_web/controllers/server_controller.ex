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
    case Servers.get(id) do
      nil -> send_resp(conn, 404, "")
      server -> render(conn, "server.json", d(%{server}))
    end
  end

  def index(conn, _params) do
    servers = Servers.list()
    render(conn, "servers.json", %{servers: servers})
  end

  def access(conn, params) do
    {server, subpath} = Servers.server_for_path(params["path"])
    route = Servers.access_path(server, conn.method, subpath)
    conn
    |> put_resp_content_type(route.response_type)
    |> send_resp(route.status_code, route.response_body)
  end

  def start(conn, %{"server_id" => server_id}) do
    case Servers.get(server_id) do
      nil -> send_resp(conn, 404, "")
      server -> render(conn, "server.json", d(%{server}))
    end
  end
end
