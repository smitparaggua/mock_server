defmodule MockServer.RepoTest do
  use ExUnit.Case, async: true
  alias MockServer.Repo
  alias MockServer.Changeset

  defmodule Person do
    defstruct [:name, :age]
  end

  defmodule Address do
    defstruct [:street, :city]
  end

  describe "insert" do
    test "allows inserting valid changesets" do
      changeset = Changeset.cast(%Person{}, %{name: "Joe"}, [:name])
      assert {:ok, created} = Repo.insert(changeset)
      assert created.name == "Joe"
      assert created.id
    end
  end

  describe "get" do
    test "created records are retrievable by ID" do
      changeset = Changeset.cast(%Person{}, %{name: "Joe"}, [:name])
      {:ok, created} = Repo.insert(changeset)
      assert Repo.get(Person, created.id) == created
    end

    test "separates records of different models" do
      changeset = Changeset.cast(%Person{}, %{name: "Joe"}, [:name])
      {:ok, created} = Repo.insert(changeset)
      refute Repo.get(Address, created.id)
    end
  end
end
