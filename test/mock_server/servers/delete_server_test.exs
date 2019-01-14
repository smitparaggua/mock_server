defmodule MockServer.ServersTest.DeleteTest do
  use MockServer.DataCase
  alias MockServer.Servers
  alias MockServer.TestSupport.ServerFactory

  @moduletag :run_server_processes

  test "returns not found when server does not exist" do
    assert Servers.delete("fake_id") == :not_found
  end

  test "deletes the server" do
    server = ServerFactory.create()
    Servers.delete(server.id)
    assert Servers.get(server.id) == nil
  end

  test "returns deleted server" do
    server = ServerFactory.create()
    {:ok, deleted} = Servers.delete(server.id)
    assert deleted.id == server.id
    assert deleted.name == server.name
    assert deleted.path == server.path
  end

  test "deletes server's routes" do
    server = ServerFactory.create_with_route()
    Servers.delete(server.id)
    assert Servers.list_routes(server.id) == []
  end

  test "stops running servers" do
    server = ServerFactory.create_with_route()
    route = Enum.at(server.routes, 0)
    Servers.run(server)
    Servers.delete(server.id)
    assert Servers.access_path(server, route.method, route.path) == :not_found
  end
end
