defmodule MockServer.ServersTest.ListTest do
  use MockServer.DataCase
  alias MockServer.Servers
  alias MockServer.TestSupport.{ServerFactory, RouteFactory}

  @moduletag :run_server_processes

  describe "list" do
    test "returns all servers starting from most recently created" do
      first = Map.put(ServerFactory.create(), :running?, false)
      :timer.sleep(1000)
      second = Map.put(ServerFactory.create(), :running?, false)
      assert Servers.list() == [second, first]
    end

    test "running servers are tagged as running" do
      server = ServerFactory.create()
      Servers.run(server)
      assert Servers.list() == [Map.put(server, :running?, true)]
    end

    test "allows retrieval of routes" do
      server = ServerFactory.create()
      route = RouteFactory.create(%{path: "/test", server_id: server.id})
      servers = Servers.list(with_routes: true)
      assert Enum.at(servers, 0).routes == [route]
    end
  end
end
