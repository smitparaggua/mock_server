defmodule MockServerWeb.ServerControllerTest do
  use MockServerWeb.ConnCase
  import Destructure

  @valid_server_attributes %{
    name: "Server 1",
    path: "/server1",
    description: "Test Server"
  }

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

  describe "created servers" do
    setup d(%{conn}) do
      created =
        conn
        |> post(server_path(conn, :create), @valid_server_attributes)
        |> json_response(201)

      {:ok, d(%{created: created})}
    end

    test "are retrievable", d(%{conn, created}) do
      body =
        conn
        |> get(server_path(conn, :show, created["id"]))
        |> json_response(200)

      assert body == created
    end
  end
end
