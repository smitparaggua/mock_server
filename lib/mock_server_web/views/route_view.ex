defmodule MockServerWeb.RouteView do
  use MockServerWeb, :view
  import Destructure
  alias MockServerWeb.ErrorView

  @route_attributes ~w(
    id method path description status_code response_type
    server_id response_body response_delay_seconds
  )a

  def render("route.json", d%{route}) do
    Map.take(route, @route_attributes)
  end

  def render("route.json", d%{changeset}) do
    ErrorView.render("invalid_params", d%{changeset})
  end

  def render("routes.json", d%{routes}) do
    Enum.map(routes, &render("route.json", %{route: &1}))
  end

  def render("route_not_found", _assigns) do
    %{code: "RT002", message: ""}
  end
end
