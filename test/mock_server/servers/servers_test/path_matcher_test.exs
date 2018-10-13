defmodule MockServer.ServersTest.PathMatcherTest do
  use MockServer.DataCase
  alias MockServer.Servers

  @moduletag :run_server_processes

  test "returns the server when match exists" do
    {:ok, server} = Servers.create(%{name: "Server", path: "/server"})
    Servers.run(server)
    assert Servers.server_for_path(["server"]) == {server, []}
  end

  test "returns nil when no match exists" do
    assert Servers.server_for_path(["server"]) == nil
  end

  test "matches the first server based on creation" do
    {:ok, matched} = Servers.create(%{name: "Server 1", path: "/server"})
    {:ok, second} = Servers.create(%{name: "Server 2", path: "/server/2"})
    Servers.run(matched)
    Servers.run(second)
    assert Servers.server_for_path(["server", "2"]) == {matched, ["2"]}
  end

  test "supports matching nested path" do
    {:ok, first} = Servers.create(%{name: "Server 1", path: "/server/1"})
    {:ok, matched} = Servers.create(%{name: "Server 2", path: "/server/2"})
    Servers.run(first)
    Servers.run(matched)
    assert Servers.server_for_path(["server", "2", "subpath"]) == {matched, ["subpath"]}
  end
end
