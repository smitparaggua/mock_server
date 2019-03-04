defmodule MockServerWeb.ErrorView do
  use MockServerWeb, :view
  import Destructure

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  def render("invalid_params", d%{changeset}) do
    details = Enum.reduce(changeset.errors, %{}, fn ({key, {msg, _opts}}, acc) ->
      Map.update(acc, key, [msg], &([msg] ++ &1))
    end)

    %{code: "0001", message: "Invalid Parameters", details: details}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
