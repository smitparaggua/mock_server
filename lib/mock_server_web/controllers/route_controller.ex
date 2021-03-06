defmodule MockServerWeb.RouteController do
  use MockServerWeb, :controller
  import Destructure

  alias MockServer.Servers

  def create(conn, params) do
    case Servers.add_route(params["server_id"], params) do
      {:ok, route} ->
        conn
        |> put_status(:created)
        |> render("route.json", d%{route})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> render("route.json", d%{changeset})
    end
  end

  def index(conn, params) do
    routes = Servers.list_routes(params["server_id"])
    render(conn, "routes.json", d%{routes})
  end

  def show(conn, %{"id" => id}) do
    case Servers.get_route(id) do
      nil -> send_resp(conn, 404, "")
      route -> render(conn, "route.json", d%{route})
    end
  end

  def delete(conn, %{"id" => id}) do
    case Servers.delete_route(id) do
      :not_found -> send_resp(conn, 404, "")
      {:ok, route} -> render(conn, "route.json", d%{route})
    end
  end
end
