defmodule MockServer.Repo.Migrations.AddRouteDeleteCascade do
  use Ecto.Migration

  def up do
    drop(constraint :routes, "routes_server_id_fkey")
    alter table(:routes) do
      modify :server_id, references(:servers, type: :binary_id, on_delete: :delete_all)
    end
  end

  def down do
    drop(constraint :routes, "routes_server_id_fkey")
    alter table(:routes) do
      modify :server_id, references(:servers, type: :binary_id)
    end
  end
end
