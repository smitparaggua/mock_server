defmodule MockServer.RepoTest do
  use MockServer.DataCase
  alias MockServer.{Assertions}

  defmodule Person do
    defstruct [:name, :age]
  end

  defmodule Address do
    defstruct [:street, :city]
  end

  describe ".insert/1" do
    test "allows inserting valid changesets" do
      changeset = Changeset.cast(%Person{}, %{name: "Joe"}, [:name])
      assert {:ok, created} = Repo.insert(changeset)
      assert created.name == "Joe"
      assert created.id
    end

    test "allows inserting structs directly" do
      assert {:ok, created} = Repo.insert(%Person{name: "Joe"})
      assert created.name == "Joe"
      assert created.id
    end
  end

  describe ".get/2" do
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

  describe ".list/1" do
    test "returns all records in the collection" do
      created = insert_records()
      list = Repo.list(Person)
      Assertions.matches_members?(list, created)
    end

    test "returns empty list when collection does not exist" do
      assert Repo.list(Person) == []
    end

    test "allows ordering ascending" do
      created = insert_records()
      list = Repo.list(Person, order: {:name, :asc})
      assert list ==
        [Enum.at(created, 1), Enum.at(created, 0), Enum.at(created, 2)]
    end

    test "allows ordering descending" do
      created = insert_records()
      list = Repo.list(Person, order: {:name, :desc})
      assert list ==
        [Enum.at(created, 2), Enum.at(created, 0), Enum.at(created, 1)]
    end

    defp insert_records() do
      {:ok, created1} = Repo.insert(%Person{name: "Joe"})
      {:ok, created2} = Repo.insert(%Person{name: "Andy"})
      {:ok, created3} = Repo.insert(%Person{name: "Ken"})
      [created1, created2, created3]
    end
  end

  describe ".clear/0" do
    test "deletes all records" do
      Repo.insert(%Person{name: "Joe"})
      Repo.insert(%Address{street: "San Rafael St."})
      Repo.clear()
      assert Repo.list(Person) == []
      assert Repo.list(Address) == []
    end
  end
end
