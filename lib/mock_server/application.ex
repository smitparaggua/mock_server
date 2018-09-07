defmodule MockServer.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    children =
      if Application.get_env(:mock_server, :initialize_server_processes) do
        [
          supervisor(MockServerWeb.Endpoint, []),
          supervisor(MockServer.Repo, []),
          worker(MockServer.Servers.RunningRegistry, []),
          supervisor(
            DynamicSupervisor, [[strategy: :one_for_one]],
            name: MockServer.Servers.RunningServerSupervisor
          )
        ]
      else
        [
          supervisor(MockServerWeb.Endpoint, []),
          supervisor(MockServer.Repo, [])
        ]
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MockServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MockServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
