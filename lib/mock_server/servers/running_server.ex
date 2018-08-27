defmodule MockServer.Servers.RunningServer do
  use GenServer

  def access_path(server_pid, method, path) do
    GenServer.call(server_pid, {:access_path, method, path})
  end

  def start_link({server, opts}) do
    GenServer.start_link(__MODULE__, server, opts)
  end

  def start_link(server) do
    start_link({server, []})
  end

  def init(server_info) do
    {:ok, %{server: server_info, routes: server_info.routes}}
  end

  def handle_call({:access_path, method, path}, _from, state) do
    route = Enum.find(state.routes, fn route ->
      route.method == method && route.path == path
    end)

    result =
      if route do
        %{
          status_code: route.status_code,
          response_type: route.response_type,
          response_body: route.response_body
        }
      else
        %{
          status_code: 404,
          response_type: "text/plain",
          response_body: "Not found"
        }
      end

    {:reply, result, state}
  end
end
