defmodule MockServer.ServersTest do
  use MockServer.DataCase, async: true
  import Destructure
  alias MockServer.Servers
  alias MockServer.TestSupport.ServerFactory

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

    test "returns nil when retrieving with non-uuid string" do
      assert Servers.get("not-uuid") == nil
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

    test "does not include routes of other servers" do
      server_1 = ServerFactory.create_with_route()
      ServerFactory.create_with_route()
      assert Servers.list_routes(server_1.id) == server_1.routes
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

  describe "delete_route" do
    setup do
      route =
        ServerFactory.create_with_route()
        |> Map.get(:routes)
        |> Enum.at(0)

      {:ok, d%{route}}
    end

    test "delete_route returns deleted route", d%{route} do
      {:ok, deleted} = Servers.delete_route(route.id)
      assert deleted.id == route.id
    end

    test "delete_route make the route unretrievable", d%{route} do
      Servers.delete_route(route.id)
      assert Servers.get_route(route.id) == nil
    end

    test "delete_route returns :not_found when route does not exist" do
      assert Servers.delete_route("fake-id") == :not_found
    end
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

  describe "get_route" do
    test "returns route with the specified id" do
      route =
        ServerFactory.create_with_route()
        |> Map.get(:routes)
        |> Enum.at(0)

      assert route == Servers.get_route(route.id)
    end

    test "returns nil for non existent id" do
      fake_id = UUID.uuid4()
      assert Servers.get_route(fake_id) == nil
      assert Servers.get_route("not-uuid") == nil
    end
  end
end
