defmodule MockServer.Repo.Migrations.CreateServer do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :name, :string
      add :path, :string
      add :description, :text
      timestamps()
    end

    create unique_index(:servers, [:name])
    create unique_index(:servers, [:path])
  end
end
