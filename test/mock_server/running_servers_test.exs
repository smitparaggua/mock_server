defmodule MockServer.RunningServerTest do
  use MockServer.DataCase
  alias MockServer.Servers

  test "created servers should be accessible" do
    {:ok, server} = Servers.create(%{name: "Server 1", path: "/server"})
    route_attrs = %{
      method: "GET",
      path: "/hello",
      status_code: 200,
      response_type: "application/json",
      response_body: ~S({"hello": "world"})
    }
    {:ok, route} = Servers.add_route(route_attrs)
    # I should be able to start_link it since I'll use start_supervised
    # Sooo.... Running it should be like start_link(<route_info>) ?
    # Servers.run(server.id)
    # start_supervised({Servers.MockServer, <route_info>}) when testing one server
    # start Servers.Supervisor instead when using Servers.run(server.id)
    #   since it will attach to a named supervisor
    start_supervised(DynamicSupervisor, name: MockServer.Servers.Supervisor)
    Servers.run(server)
    assert Servers.access_path(server, "/hello") == %{
      status_code: 200,
      response_type: "application/json",
      response_body: ~S({"hello": "world"})
    }
  end
end
