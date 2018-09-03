defmodule MockServer.Servers do
  alias MockServer.Repo
  alias MockServer.Servers.{
    Server, Query, Route, RunningServer, RunningServerSupervisor,
    RunningRegistry
  }

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

  def list_routes(_server_id) do
    Repo.all(Route)
  end

  def run(server) do
    server = Repo.preload(server, :routes)
    {:ok, pid} = DynamicSupervisor.start_child(
      RunningServerSupervisor, {RunningServer, server}
    )

    RunningRegistry.register(server.id, pid)
  end

  def access_path(server, method, path) do
    server.id
    |> RunningRegistry.pid_of()
    |> RunningServer.access_path(method, path)
  end

  # Routing
  def extract_server_path(path) do
    :binary.match()
    {path, "/"}
  end
end
