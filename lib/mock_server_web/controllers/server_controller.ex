defmodule MockServerWeb.ServerController do
  use MockServerWeb, :controller
  alias MockServer.Servers

  def create(conn, params) do
    {:ok, server} = Servers.create(params)
    conn
    |> put_status(:created)
    |> render("server.json", server)
  end

  def show(conn, %{"id" => id} = params) do
    IO.inspect(params)
    server = Servers.get(id)
    render(conn, "server.json", server)
  end
end
