defmodule MockServerWeb.ServerControllerTest do
  use MockServerWeb.ConnCase
  use MockServer.DataCase
  import Destructure

  @valid_server_attributes %{
    name: "Server 1",
    path: "/server1",
    description: "Test Server"
  }

  describe "create" do
    test "create server returns the server created", d(%{conn}) do
      body =
        conn
        |> post(server_path(conn, :create), @valid_server_attributes)
        |> json_response(201)

      assert %{
        "id" => _,
        "name" => "Server 1",
        "path" => "/server1",
        "description" => "Test Server"
      } = body
    end
  end

  describe "get" do
    setup d(%{conn}) do
      created = create_server(conn)
      {:ok, d(%{created})}
    end

    test "existing servers are retrievable", d(%{conn, created}) do
      body =
        conn
        |> get(server_path(conn, :show, created["id"]))
        |> json_response(200)

      assert body == created
    end

    test "returns not found when server does not exist", d(%{conn}) do
      response = get(conn, server_path(conn, :show, "not-found"))
      assert response.status == 404
    end
  end

  describe "index" do
    test "returns list of servers in ascending order by name", d(%{conn}) do
      servers = [
        create_server(conn, %{name: "A Server", path: "/server/a"}),
        create_server(conn, %{name: "B Server", path: "/server/b"}),
        create_server(conn, %{name: "C Server", path: "/server/c"})
      ]

      body =
        conn
        |> get(server_path(conn, :index))
        |> json_response(200)

      assert body["data"] == servers
    end
  end

  defp create_server(conn, server_attributes \\ @valid_server_attributes) do
    conn
    |> post(server_path(conn, :create), server_attributes)
    |> json_response(201)
  end
end
