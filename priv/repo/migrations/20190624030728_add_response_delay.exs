defmodule MockServer.Repo.Migrations.AddResponseDelay do
  use Ecto.Migration

  def change do
    alter table(:routes) do
      add :response_delay_seconds, :integer
    end
  end
end
