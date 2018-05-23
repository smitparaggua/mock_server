defmodule MockServer.Repo.Migrations.CreateServer do
  use Ecto.Migration

  def change do
    create table(:servers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :path, :string
      add :description, :text
      timestamps()
    end

    create unique_index(:servers, [:name])
    create unique_index(:servers, [:path])
  end
end
