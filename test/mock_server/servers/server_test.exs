defmodule MockServer.Servers.ServerTest do
  use MockServer.DataCase, async: true
  alias MockServer.Servers.Server

  describe "changeset" do
    test "requires name and path" do
      errors =
        %Server{}
        |> Server.changeset(%{})
        |> errors_on()

      assert "can't be blank" in errors.name
      assert "can't be blank" in errors.path
    end
  end
end
