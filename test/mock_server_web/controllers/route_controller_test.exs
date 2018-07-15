defmodule MockServerWeb.RouteControllerTest do
  use MockServerWeb.ConnCase, async: true
  import Destructure

  alias MockServer.TestSupport.ServersFactory

  describe "create" do
    setup d%{conn} do
      server = ServersFactory.create()
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
        "method" => ["can't be blank"],
        "path" => ["can't be blank"],
        "status_code" => ["can't be blank"],
        "response_type" => ["can't be blank"],
        "response_body" => ["can't be blank"]
      }
    end
  end

  test "list routes returns all the server's routes", d%{conn} do
    server = ServersFactory.create()
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
end
