defmodule MockServer.Servers do
  defmodule Server do
    import MockServer.Changeset

    defstruct [:id, :name, :path, :description]

    def changeset(%Server{} = server, params) do
      cast(server, params, [:name, :path, :description])
    end
  end

  alias MockServer.Repo

  def create(params) do
    Server.changeset(%Server{}, params)
    |> Repo.insert()
  end

  def get(server_id) do
    Repo.get(Server, server_id)
  end
end
