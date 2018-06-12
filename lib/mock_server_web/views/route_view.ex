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
end
