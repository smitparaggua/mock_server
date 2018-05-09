defmodule MockServer.ListUtilsTest do
  use ExUnit.Case, async: true

  import MockServer.ListUtils, only: [element_occurrence: 1]

  describe "element_occurrence" do
    test "returns empty for empty lists" do
      assert element_occurrence([]) == %{}
    end

    test "returns occurrences of elements on the list" do
      assert element_occurrence(["a", "b"]) == %{"a" => 1, "b" => 1}
      assert element_occurrence(["a", "b", "a"]) == %{"a" => 2, "b" => 1}
    end
  end
end
