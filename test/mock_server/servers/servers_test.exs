defmodule MockServer.ServersTest do
  use MockServer.DataCase, async: true
  alias MockServer.Servers

  @valid_server_attributes %{
    name: "Server 1",
    path: "/server1",
    description: "Test Server"
  }

  @route_attrs %{
    method: "GET",
    path: "/some-route"
  }

  describe "create" do
    test "successful creation of server returns ok" do
      assert {:ok, server} = Servers.create(@valid_server_attributes)
      assert %{
        id: _,
        name: "Server 1",
        path: "/server1",
        description: "Test Server"
      } = server
    end
  end

  describe "get" do
    test "created servers are retrievable by ID" do
      assert {:ok, server} = Servers.create(@valid_server_attributes)
      assert Servers.get(server.id) == server
    end
  end

  describe "list" do
    test "returns all servers starting from most recently created" do
      {:ok, first} = Servers.create(%{name: "First Server", path: "/first"})
      {:ok, second} = Servers.create(%{name: "Second Server", path: "/second"})
      assert Servers.list() == [second, first]
    end
  end

  describe "add_route" do
    test "returns new route" do
      {:ok, server} = Servers.create(@valid_server_attributes)
      {:ok, route} = Servers.add_route(server.id, @route_attrs)
      assert server.id
      assert @route_attrs = route
    end
  end
end
