defmodule MockServerWeb.ServerController do
  use MockServerWeb, :controller
  alias MockServer.Servers

  def create(conn, params) do
    case Servers.create(params) do
      {:ok, server} ->
        conn
        |> put_status(:created)
        |> render("server.json", server)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> render("server.json", changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case Servers.get(id) do
      nil -> send_resp(conn, 404, "")
      server -> render(conn, "server.json", server)
    end
  end

  def index(conn, params) do
    servers = Servers.list(with_routes: params["with_routes"] == "true")
    render(conn, "servers.json", %{servers: servers})
  end

  def access(conn, params) do
    case Servers.server_for_path(params["path"]) do
      {server, subpath} ->
        {:ok, route} = Servers.access_path(server, conn.method, subpath)
        conn
        |> put_resp_content_type(route.response_type)
        |> send_resp(route.status_code, route.response_body)

      nil ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(404, "Server not found")
    end
  end

  def start(conn, %{"server_id" => server_id}) do
    case Servers.get(server_id) do
      nil -> send_resp(conn, 404, "")
      server ->
        Servers.run(server)
        render(conn, "server.json", server)
    end
  end

  def stop(conn, %{"server_id" => server_id}) do
    case Servers.get(server_id) do
      nil -> send_resp(conn, 404, "")
      server ->
        Servers.stop(server)
        render(conn, "server.json", server)
    end
  end

  def delete(conn, %{"id" => server_id}) do
    case Servers.delete(server_id) do
      :not_found ->
        conn
        |> put_status(:not_found)
        |> render("server_not_found.json")

      {:ok, server} ->
        render(conn, "server.json", server)
    end
  end
end
