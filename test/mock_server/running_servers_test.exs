defmodule MockServer.RunningServerTest do
  use MockServer.DataCase
  alias MockServer.Servers
  alias Servers.{RunningServerSupervisor, RunningRegistry}

  @tag :wip
  test "created servers should be accessible" do
    {:ok, server} = Servers.create(%{name: "Server 1", path: "/server"})
    route_attrs = %{
      method: "GET",
      path: "/hello",
      status_code: 200,
      response_type: "application/json",
      response_body: ~S({"hello": "world"})
    }
    {:ok, route} = Servers.add_route(server.id, route_attrs)
    start_supervised!(
      {DynamicSupervisor, name: RunningServerSupervisor, strategy: :one_for_one}
    )

    start_supervised!(RunningRegistry)
    Servers.run(server)
    assert Servers.access_path(server, "GET", "/hello") == %{
      status_code: 200,
      response_type: "application/json",
      response_body: ~S({"hello": "world"})
    }
  end
end
