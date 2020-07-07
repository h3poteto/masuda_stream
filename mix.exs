defmodule MasudaStream.MixProject do
  use Mix.Project

  def project do
    [
      app: :masuda_stream,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {MasudaStream.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.10"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:httpoison, "~> 1.6"},
      {:ex_rfc3986, "~> 0.3.0"},
      {:floki, "~> 0.27.0"},
      # We can not update elixir 1.9.1, because html5ever does not support OTP22.
      # So I'm waiting for this pull request: https://github.com/hansihe/html5ever_elixir/pull/14
      {:html5ever, "~> 0.8.0"},
      {:plug, "~> 1.0"},
      {:json, "~> 1.2"},
      # To parse RSS 1.0
      {:quinn, "~> 1.1"},
      {:timex, "~> 3.5"},
      {:credo, "~> 1.4.0", only: [:dev, :test], runtime: false},
      {:ueberauth_hatena, "~> 0.1.0"},
      {:oauther, "~> 1.1"},
      {:poison, "~> 4.0"},
      {:quantum, "~> 2.3"},
      {:ex_slack_logger, "~> 0.1.0"},
      {:rollbax, "~> 0.11"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
