defmodule MockServer.Servers do
  alias MockServer.Repo
  alias MockServer.Servers.{Server, Query, Route}

  def create(params) do
    Server.changeset(%Server{}, params)
    |> Repo.insert()
  end

  def get(server_id), do: Repo.get(Server, server_id)

  def list(), do: Repo.all(Server |> Query.from_recently_created())

  def add_route(server_id, route_params) do
    Route.changeset(%Route{server_id: server_id}, route_params)
    |> Repo.insert()
  end

  def list_routes(server_id) do
    Repo.all(Route)
  end
end
