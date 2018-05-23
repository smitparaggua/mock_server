defmodule MockServer.ServersTest do
  use MockServer.DataCase, async: true
  alias MockServer.Servers

  @valid_server_attributes %{
    name: "Server 1",
    path: "/server1",
    description: "Test Server"
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
end
