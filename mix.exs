defmodule MockServer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mock_server,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {MockServer.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_html, "~> 2.10"},
      {:gettext, "~> 0.11"},
      {:destructure, "~> 0.2.3"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:uuid, "~> 1.1.8"},
      {:ecto_sql, "~> 3.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:postgrex, "~> 0.14.1"},
      {:jason, "~> 1.0"},
      {:key_convert, "~> 0.3.0"},
      {:httpoison, "~> 1.2"},
      {:ex_random_string, "~> 1.0.1"},

      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false}
    ]
  end
end
