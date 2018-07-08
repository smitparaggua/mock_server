defmodule MockServer.Servers.RouteTest do
  use MockServer.DataCase

  alias MockServer.Servers.Route

  @valid_params %{
    method: "GET",
    path: "/sample",
    status_code: 200,
    response_type: "text",
    response_body: "hello, world"
  }

  test "valid attributes" do
    changeset = Route.changeset(%Route{}, @valid_params)
    assert changeset.valid?
  end

  test "requires method, path, status_code, response_type, response_body" do
    changeset = Route.changeset(%Route{}, %{})
    refute changeset.valid?
    assert {:validation, :required} in error_validators(changeset, :method)
    assert {:validation, :required} in error_validators(changeset, :path)
    assert {:validation, :required} in error_validators(changeset, :status_code)
    assert {:validation, :required} in error_validators(changeset, :response_type)
    assert {:validation, :required} in error_validators(changeset, :response_body)
  end

  test "accepts 200-599 status codes" do
    Enum.each([200, 599, 305, 400], fn status ->
      params = Map.put(@valid_params, :status_code, status)
      assert Route.changeset(%Route{}, params).valid?
    end)
  end

  test "rejects status codes outside 200-599" do
    Enum.each([199, 600], fn status ->
      params = Map.put(@valid_params, :status_code, status)
      changeset = Route.changeset(%Route{}, params)
      refute changeset.valid?
      assert {:validation, :http_status} in error_validators(changeset, :status_code)
    end)
  end

  test "accepts valid HTTP methods" do
    assert changeset_with(:method, "GET").valid?
    assert changeset_with(:method, "POST").valid?
    assert changeset_with(:method, "PUT").valid?
    assert changeset_with(:method, "PATCH").valid?
    assert changeset_with(:method, "DELETE").valid?
  end

  test "rejects invalid HTTP methods" do
    changeset = changeset_with(:method, "INVALID")
    refute changeset.valid?
    assert {:validation, :http_verb} in error_validators(changeset, :method)
  end

  test "accepts valid response types" do
    assert changeset_with(:response_type, "application/json").valid?
    assert changeset_with(:response_type, "text/plain").valid?
    assert changeset_with(:response_type, "application/javascript").valid?
    assert changeset_with(:response_type, "application/xml").valid?
    assert changeset_with(:response_type, "text/xml").valid?
    assert changeset_with(:response_type, "text/html").valid?
  end

  test "rejects invalid response types" do
    changeset = changeset_with(:response_type, "not valid")
    refute changeset.valid?
    errors = error_validators(changeset, :response_type)
    assert {:validation, :http_response_type} in errors
  end

  defp changeset_with(field, value) do
    @valid_params
    |> Map.put(field, value)
    |> Route.changeset()
  end

  def error_validators(changeset, attribute) do
    IO.inspect(changeset)
    elem(changeset.errors[attribute], 1)
  end
end
