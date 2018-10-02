defmodule MockServer.Application do
  use Application

  def start(_type, _args) do
    children =
      if Application.get_env(:mock_server, :initialize_server_processes) do
        Enum.concat(base_processes(), server_processes())
      else
        base_processes()
      end

    opts = [strategy: :one_for_one, name: MockServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp base_processes do
    [
      %{
        id: MockServerWeb.Endpoint,
        start: {MockServerWeb.Endpoint, :start_link, []},
        type: :supervisor
      },

      %{
        id: MockServer.Repo,
        start: {MockServer.Repo, :start_link, []},
        type: :supervisor
      }
    ]
  end

  defp server_processes do
    [
      %{
        id: DynamicSupervisor,
        start: {
          DynamicSupervisor, :start_link, [
            strategy: :one_for_one,
            name: MockServer.Servers.RunningServerSupervisor
          ]
        },
        type: :supervisor
      },

      {MockServer.Servers.RunningRegistry, []}
    ]
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MockServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
