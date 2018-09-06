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
    path = "/#{Enum.join(path, "/")}"
    server.id
    |> RunningRegistry.pid_of()
    |> RunningServer.access_path(method, path)
  end

  def server_for_path(path_components) when is_list(path_components) do
    servers_to_match =
      Server
      |> Query.with_path_starting_with(List.first(path_components))
      |> Repo.all()

    Enum.find_value(servers_to_match, fn %{path: path} = server ->
      server_path_components = String.split(path, "/", trim: true)
      last_component_index = length(server_path_components) - 1
      path_components_to_match = Enum.slice(path_components, 0..last_component_index)
      if path_components_to_match == server_path_components do
        {server, path_components -- server_path_components}
      end
    end)
  end

  # Routing
  def extract_server_path(path) do
    case :binary.match(path, "/", scope: {1, String.length(path) - 1}) do
      {index, _} -> String.split_at(path, index)
      :nomatch -> {path, "/"}
    end
  end
end
