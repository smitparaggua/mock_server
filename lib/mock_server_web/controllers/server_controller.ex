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

  # NOTE we may need to support server with route = /server/path
  #      instead of jus /server
  def access(conn, params) do
    [server | subpaths] = params["path"]
    # {server, path} = Servers.extract_server_path(params["path"])
    # Servers.server_for_path(params["path"])
    subpath = Enum.join(subpaths, "/")
    Servers.access_path("/#{server}", conn.method, "/#{subpaths}")
  end
end
