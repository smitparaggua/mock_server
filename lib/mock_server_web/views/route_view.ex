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

  def render("routes.json", d%{routes}) do
    Enum.map(routes, &render("route.json", %{route: &1}))
  end
end
