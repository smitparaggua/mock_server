defmodule MockServerWeb.RouteView do
  use MockServerWeb, :view
  import Destructure

  @route_attributes ~w(
    id method path description status_code response_type
    server_id response_body
  )a

  def render("route.json", d%{route}) do
    Map.take(route, @route_attributes)
  end

  def render("route.json", d%{changeset}) do
    Enum.reduce(changeset.errors, %{}, fn ({key, {msg, opts}}, acc) ->
      Map.update(acc, key, [], &([msg] ++ &1))
    end)
  end

  def render("routes.json", d%{routes}) do
    Enum.map(routes, &render("route.json", %{route: &1}))
  end
end
