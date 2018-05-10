defmodule MockServer.Assertions do
  import ExUnit.Assertions
  alias MockServer.ListUtils

  def matches_members?(left, right) do
    matched = ListUtils.element_occurrence(left) == ListUtils.element_occurrence(right)
    assert matched, "left : #{inspect left}\nright: #{inspect right}"
  end
end
