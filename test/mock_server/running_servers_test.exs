defmodule MockServer.RunningServerTest do
  use MockServer.DataCase
  alias MockServer.Servers
  alias Servers.{RunningServerSupervisor, RunningRegistry}

  # NOTE: This test might be too complicated (a bit like integration test)
  # we might need to move this away from unit tests
  setup do
    start_supervised!(RunningRegistry)
    start_supervised!(
      {DynamicSupervisor, name: RunningServerSupervisor, strategy: :one_for_one}
    )
    {:ok, server} = Servers.create(%{name: "Server 1", path: "/server"})
    {:ok, %{server: server}}
  end

  test "created servers should be accessible", %{server: server} do
    route_attrs = %{
      method: "GET",
      path: "/hello",
      status_code: 200,
      response_type: "application/json",
      response_body: ~S({"hello": "world"})
    }
    {:ok, route} = Servers.add_route(server.id, route_attrs)
    Servers.run(server)
    assert Servers.access_path(server, "GET", "/hello") == %{
      status_code: 200,
      response_type: "application/json",
      response_body: ~S({"hello": "world"})
    }
  end
end