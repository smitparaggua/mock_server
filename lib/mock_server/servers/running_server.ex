defmodule MockServer.Servers.RunningServer do
  use GenServer

  def access_path(server_pid, method, path) do
    GenServer.call(server_pid, {:access_path, method, path}, :infinity)
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

  def handle_call({:access_path, method, path}, from, state) do
    [path | _query] = String.split(path, "?", parts: 2)
    route = Enum.find(state.routes, fn route ->
      route.method == method && route.path == path
    end)

    if route do
      result = %{
        status_code: route.status_code,
        response_type: route.response_type,
        response_body: route.response_body
      }

      # TODO add test for delay and refactor this shit
      case route.response_delay_seconds do
        delay when delay in [nil, 0] ->
          {:reply, result, state}

        delay ->
          Task.start(fn ->
            :timer.sleep(1000 * delay)
            GenServer.reply(from, result)
          end)

          {:noreply, state}
      end
    else
      result = %{
        status_code: 404,
        response_type: "text/plain",
        response_body: "Not found"
      }

      {:reply, result, state}
    end
  end
end
