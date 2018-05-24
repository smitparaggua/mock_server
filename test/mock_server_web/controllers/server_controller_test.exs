defmodule MockServerWeb.ServerControllerTest do
  use MockServerWeb.ConnCase, async: true
  import Destructure
  alias MockServer.Assertions

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
      non_existing_id = "51f41bf1-0b6e-4375-b5e7-4f6546f63212"
      response = get(conn, server_path(conn, :show, non_existing_id))
      assert response.status == 404
    end
  end

  describe "index" do
    test "returns list of servers", d(%{conn}) do
      servers = [
        create_server(conn, %{name: "A Server", path: "/server/a"}),
        create_server(conn, %{name: "B Server", path: "/server/b"}),
        create_server(conn, %{name: "C Server", path: "/server/c"})
      ]

      body =
        conn
        |> get(server_path(conn, :index))
        |> json_response(200)

      assert Assertions.matches_members?(body["data"], servers)
    end
  end

  defp create_server(conn, server_attributes \\ @valid_server_attributes) do
    conn
    |> post(server_path(conn, :create), server_attributes)
    |> json_response(201)
  end
end
