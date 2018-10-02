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

    test "prevents duplicate paths" do
      server_1 = %{name: "Server 1", path: "/server"}
      server_2 = %{name: "Server 2", path: "/server"}
      Servers.create(server_1)
      assert {:error, changeset} = Servers.create(server_2)
      assert {:path, ["has already been taken"]} in errors_on(changeset)
    end

    test "prevents duplicate names" do
      server_1 = %{name: "Server", path: "/server-1"}
      server_2 = %{name: "Server", path: "/server-1"}
      Servers.create(server_1)
      assert {:error, changeset} = Servers.create(server_2)
      assert {:name, ["has already been taken"]} in errors_on(changeset)
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
      attrs = route_attrs()
      {:ok, server} = Servers.create(@valid_server_attributes)
      {:ok, route} = Servers.add_route(server.id, attrs)
      assert server.id
      assert route.method == attrs.method
      assert route.path == attrs.path
      assert route.status_code == attrs.status_code
      assert route.response_body == attrs.response_body
      assert route.response_type == attrs.response_type
    end
  end

  describe "list_routes" do
    test "returns all the routes of a server" do
      {:ok, server} = Servers.create(@valid_server_attributes)
      {:ok, route_1} = Servers.add_route(server.id, route_attrs(%{path: "/path-1"}))
      {:ok, route_2} = Servers.add_route(server.id, route_attrs(%{path: "/path-2"}))
      routes = Servers.list_routes(server.id)
      assert Enum.count(routes) == 2
      assert route_1 in routes
      assert route_2 in routes
    end
  end

  def route_attrs(custom \\ %{}) do
    default = %{
      method: "GET",
      path: "/path",
      status_code: 200,
      response_type: "application/json",
      response_body: ~S({"hello": "world"})
    }

    Map.merge(default, custom)
  end

  describe "extract_server_path" do
    test "returns root subpath when accessing server path only" do
      result = Servers.extract_server_path("/server")
      assert result == {"/server", "/"}
    end

    test "returns root path as server and subpath as path" do
      result = Servers.extract_server_path("/server/subpath/123")
      assert result == {"/server", "/subpath/123"}
    end
  end

  describe "server_for_path" do
    # TODO now that this test require RunningRegistry, it's no longer parallelizable

    test "returns the server when match exists" do
      {:ok, server} = Servers.create(%{name: "Server", path: "/server"})
      assert Servers.server_for_path(["server"]) == {server, []}
    end

    test "returns nil when no match exists" do
      assert Servers.server_for_path(["server"]) == nil
    end

    test "matches the first server based on creation" do
      {:ok, matched} = Servers.create(%{name: "Server", path: "/server"})
      Servers.create(%{name: "Server", path: "/server/2"})
      assert Servers.server_for_path(["server", "2"]) == {matched, ["2"]}
    end

    test "supports matching nested path" do
      Servers.create(%{name: "Server 1", path: "/server/1"})
      {:ok, matched} = Servers.create(%{name: "Server 2", path: "/server/2"})
      assert Servers.server_for_path(["server", "2", "subpath"]) == {matched, ["subpath"]}
    end
  end
end
