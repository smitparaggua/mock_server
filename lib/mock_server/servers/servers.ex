defmodule MockServer.Servers do
  alias MockServer.Repo
  alias MockServer.Servers.Server

  def create(params) do
    Server.changeset(%Server{}, params)
    |> Repo.insert()
  end

  def get(server_id), do: Repo.get(Server, server_id)

  def list(), do: Repo.all(Server)
end
