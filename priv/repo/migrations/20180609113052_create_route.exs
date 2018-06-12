defmodule MockServer.Repo.Migrations.CreateRoute do
  use Ecto.Migration

  def change do
    create table(:routes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :server_id, references(:servers), null: false
      add :method, :string
      add :path, :string
      add :description, :text
      add :status_code, :integer
      add :response_type, :string
      add :response_body, :text
    end
  end
end
