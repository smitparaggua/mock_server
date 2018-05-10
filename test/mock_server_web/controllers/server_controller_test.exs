defmodule MockServerWeb.ServerControllerTest do
  use MockServerWeb.ConnCase
  import Destructure
  alias MockServer.{Assertions, Servers}

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
  end

  describe "index" do
    test "returns list of servers", d(%{conn}) do
      Servers.clear()
      servers =
        Stream.repeatedly(fn -> create_server(conn) end)
        |> Stream.take(3)
        |> Enum.to_list()

      body =
        conn
        |> get(server_path(conn, :index))
        |> json_response(200)

      Assertions.matches_members?(body["data"], servers)
    end
  end

  defp create_server(conn) do
    conn
    |> post(server_path(conn, :create), @valid_server_attributes)
    |> json_response(201)
  end
end
