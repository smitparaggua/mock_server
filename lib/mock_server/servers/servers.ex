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

  @spec get(String.t) :: Server.t | nil
  def get(server_id) do
    case UUID.info(server_id) do
      {:ok, _} -> Repo.get(Server, server_id)
      _ -> nil
    end
  end

  def list() do
    Server
    |> Query.from_recently_created()
    |> Repo.all()
    |> add_running_information()
  end

  defp add_running_information(servers) when is_list(servers) do
    Enum.map(servers, &add_running_information/1)
  end

  defp add_running_information(server) do
    Map.put(server, :running?, RunningRegistry.running?(server.id))
  end

  @spec get_route(String.t) :: Route.t | nil
  def get_route(route_id) do
    case UUID.info(route_id) do
      {:ok, _} -> Repo.get(Route, route_id)
      _ -> nil
    end
  end

  @spec add_route(String.t, Map.t) :: {:ok, Route.t} | {:error, Ecto.Changeset.t}
  def add_route(server_id, route_params) do
    Route.changeset(%Route{server_id: server_id}, route_params)
    |> Repo.insert()
  end

  @spec delete_route(String.t) :: {:ok, Route.t} | {:error, Ecto.Changeset.t} | :not_found
  def delete_route(route_id) do
    case get_route(route_id) do
      nil -> :not_found
      route -> Repo.delete(route)
    end
  end

  @spec list_routes(String.t) :: [Server.t]
  def list_routes(server_id) do
    Route
    |> Query.with_server_id(server_id)
    |> Repo.all()
  end

  @spec run(Server.t) :: :ok
  def run(server) do
    server = Repo.preload(server, :routes)
    {:ok, pid} = DynamicSupervisor.start_child(
      RunningServerSupervisor, {RunningServer, server}
    )

    RunningRegistry.register(server.id, pid)
  end

  @spec stop(Server.t) :: {:ok, Server.t | nil}
  def stop(server) do
    stopped = if RunningRegistry.delete(server.id), do: server, else: nil
    {:ok, stopped}
  end

  @spec access_path(Server.t, String.t, [String.t] | String.t) :: {:ok, Route.t} | :not_found

  def access_path(server, method, path) when is_list(path) do
    path = "/#{Enum.join(path, "/")}"
    access_path(server, method, path)
  end

  def access_path(server, method, path) do
    case RunningRegistry.pid_of(server.id) do
      nil -> :not_found
      pid -> {:ok, RunningServer.access_path(pid, method, path)}
    end
  end

  @spec server_for_path([String.t] | String.t) :: Server.t

  def server_for_path(path_components) when is_list(path_components) do
    servers_to_match =
      Server
      |> Query.with_path_starting_with(List.first(path_components))
      |> Repo.all()

    Enum.find_value(servers_to_match, fn %{path: path} = server ->
      server_path_components = String.split(path, "/", trim: true)
      last_component_index = length(server_path_components) - 1
      path_components_to_match = Enum.slice(path_components, 0..last_component_index)
      paths_match? = path_components_to_match == server_path_components
      if paths_match? && RunningRegistry.running?(server.id) do
        {server, path_components -- server_path_components}
      end
    end)
  end

  def server_for_path(path) do
    path
    |> String.split("/", trim: true)
    |> server_for_path()
  end

  # Routing
  def extract_server_path(path) do
    case :binary.match(path, "/", scope: {1, String.length(path) - 1}) do
      {index, _} -> String.split_at(path, index)
      :nomatch -> {path, "/"}
    end
  end

  @spec delete(String.t) :: {:ok, Server.t} | :not_found
  def delete(server_id) do
    case get(server_id) do
      nil -> :not_found
      server ->
        stop(server)
        Repo.delete(server)
    end
  end
end
