defmodule MockServer.Servers do
  alias MockServer.Repo
  alias MockServer.Servers.Server
  alias MockServer.Servers.Query

  def create(params) do
    Server.changeset(%Server{}, params)
    |> Repo.insert()
  end

  def get(server_id), do: Repo.get(Server, server_id)

  def list(), do: Repo.all(Server |> Query.from_recently_created())
end
