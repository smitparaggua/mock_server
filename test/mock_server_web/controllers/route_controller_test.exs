defmodule MockServerWeb.RouteControllerTest do
  use MockServerWeb.ConnCase, async: true
  import Destructure

  alias MockServer.TestSupport.ServerFactory

  describe "create" do
    setup d%{conn} do
      server = ServerFactory.create()
      create_route = &post(conn, server_route_path(conn, :create, server.id), &1)
      {:ok, d%{server, conn, create_route}}
    end

    test "create route returns the route created", d%{conn, server} do
      route = %{
        method: "GET",
        path: "/some-route",
        description: "Test route",
        status_code: 200,
        response_type: "application/json",
        response_body: ~S({"hello": "world"})
      }

      body =
        conn
        |> post(server_route_path(conn, :create, server.id), route)
        |> json_response(201)

      assert body["id"]
      assert body["server_id"] == server.id
      assert %{
        "method" => "GET",
        "path" => "/some-route",
        "description" => "Test route",
        "status_code" => 200,
        "response_type" => "application/json",
        "response_body" => ~S({"hello": "world"})
      } = body
    end

    test "returns error when route is invalid", d%{create_route} do
      body = %{} |> create_route.() |> json_response(400)
      assert body == %{
        "code" => "0001",
        "message" => "Invalid Parameters",
        "details" => %{
          "method" => ["can't be blank"],
          "path" => ["can't be blank"],
          "status_code" => ["can't be blank"],
          "response_type" => ["can't be blank"],
          "response_body" => ["can't be blank"]
        }
      }
    end
  end

  test "list routes returns all the server's routes", d%{conn} do
    server = ServerFactory.create()
    routes =
      [route_params(%{path: "/route-1"}), route_params(%{path: "/route-2"})]
      |> Enum.map(&KeyConvert.stringify/1)

    path = server_route_path(conn, :create, server.id)
    create_route = fn route -> post(conn, path, route) end
    Enum.each(routes, create_route)

    body =
      conn
      |> get(server_route_path(conn, :index, server.id))
      |> json_response(200)

    assert includes_similar_member?(body, Enum.at(routes, 0))
    assert includes_similar_member?(body, Enum.at(routes, 1))
  end

  def route_params(custom \\ %{}) do
    default = %{
      method: "GET",
      path: "/some-route",
      description: "Test route",
      status_code: 200,
      response_type: "application/json",
      response_body: ~S({"hello": "world"})
    }

    Map.merge(default, custom)
  end

  def includes_similar_member?(collection, member) do
    member = MapSet.new(member)
    subset? = fn element ->
      element = MapSet.new(element)
      MapSet.subset?(member, element)
    end

    collection
    |> Enum.find(subset?)
    |> is_nil()
    |> Kernel.not()
  end

  describe "show" do
    test "show routes return the route in question", d%{conn} do
      route = %{
        method: "GET",
        path: "/test",
        status_code: 200,
        response_type: "text/plain",
        response_body: "hello, world"
      }

      server = ServerFactory.create_with_route(%{}, route)
      route = Enum.at(server.routes, 0)
      body =
        conn
        |> get(route_path(conn, :show, route.id))
        |> json_response(200)

      assert body["method"] == "GET"
      assert body["path"] == "/test"
      assert body["status_code"] == 200
      assert body["response_type"] == "text/plain"
      assert body["response_body"] == "hello, world"
    end

    test "returns not found when ID does not exist", d%{conn} do
      response = get(conn, route_path(conn, :show, "fake"))
      assert response.status == 404
    end
  end

  describe "delete" do
    setup do
      route =
        ServerFactory.create_with_route()
        |> Map.get(:routes)
        |> Enum.at(0)

      {:ok, d%{route}}
    end

    test "delete route returns deleted route on success", d%{conn, route} do
      body =
        conn
        |> delete(route_path(conn, :delete, route.id))
        |> json_response(200)

      assert body["id"] == route.id
      assert body["method"] == route.method
      assert body["path"] == route.path
    end

    test "deleted routes are no longer retrievable", d%{conn, route} do
      delete(conn, route_path(conn, :delete, route.id))
      response = get(conn, route_path(conn, :show, route.id))
      assert response.status == 404
    end

    test "deleting non-existent routes return 404", d%{conn} do
      response = delete(conn, route_path(conn, :delete, "non-existent-id"))
      assert response.status == 404
    end
  end
end
