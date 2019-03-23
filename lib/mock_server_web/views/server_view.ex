defmodule MockServerWeb.ServerView do
  use MockServerWeb, :view
  import Destructure

  alias MockServer.Servers.Server
  alias Ecto.Changeset
  alias MockServerWeb.{ErrorView, RouteView}

  def render("server.json", %Server{} = server) do
    base = %{
      id: server.id,
      name: server.name,
      path: server.path,
      description: server.description,
      isRunning: server.running?
    }

    case Ecto.assoc_loaded?(server.routes) do
      true ->
        routes = RouteView.render("routes.json", d%{routes: server.routes})
        Map.put(base, :routes, routes)

      _ -> base
    end
  end

  def render("server.json", %Changeset{} = changeset) do
    ErrorView.render("invalid_params", d%{changeset})
  end

  def render("servers.json", d(%{servers})) when is_list(servers) do
    %{
      data: Enum.map(servers, &render("server.json", &1))
    }
  end

  def render("server_not_found.json", _assigns) do
    %{code: "SRV002", message: "Server not found"}
  end
end
