defmodule MockServer.TestSetup do
  use ExUnit.Callbacks

  alias MockServer.Servers.{RunningRegistry, RunningServerSupervisor}

  def run_server_processes do
    start_supervised!(RunningRegistry)
    start_supervised!(
      {DynamicSupervisor, name: RunningServerSupervisor, strategy: :one_for_one}
    )
  end
end
