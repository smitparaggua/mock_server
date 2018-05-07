defmodule MockServer.ChangesetTest do
  use ExUnit.Case, async: true
  import MockServer.Changeset, only: [cast: 3]

  defmodule Person do
    defstruct [:name, :age]
  end

  describe "cast" do
    test "adds similar attributes to changes" do
      changeset = cast(%Person{}, %{name: "Joe"}, [:name])
      assert changeset.changes == %{name: "Joe"}
    end

    test "ignores unlisted attributes" do
      changeset = cast(%Person{}, %{name: "Joe", age: 26}, [:name])
      assert changeset.changes == %{name: "Joe"}
    end

    test "converts attribute keys to atom" do
      changeset = cast(%Person{}, %{"age" => 26}, [:age])
      assert changeset.changes == %{age: 26}
    end

    test "sets the provided data to changeset" do
      data = %Person{name: "Joe"}
      changeset = cast(data, %{}, [])
      assert changeset.data == data
    end
  end
end
