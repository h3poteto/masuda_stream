defmodule MasudaStream.MixProject do
  use Mix.Project

  def project do
    [
      app: :masuda_stream,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:leex] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      releases: [
        masuda_stream: [
          applications: [opentelemetry: :temporary]
        ]
      ],
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
      {:phoenix, "~> 1.7.0", override: true},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.2"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_view, "~> 2.0"},
      {:gettext, "~> 0.24"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.1"},
      {:httpoison, "~> 2.0"},
      {:floki, "~> 0.36.0"},
      {:html5ever, "~> 0.15.0"},
      {:plug, "~> 1.0"},
      {:json, "~> 1.2"},
      # To parse RSS 1.0
      {:quinn, "~> 1.1"},
      {:timex, "~> 3.5"},
      {:credo, "~> 1.7.7", only: [:dev, :test], runtime: false},
      {:ueberauth_hatena, "~> 0.2.0"},
      {:oauther, "~> 1.1"},
      {:poison, "~> 5.0"},
      {:quantum, "~> 3.3"},
      {:rollbax, "~> 0.11"},
      {:opentelemetry, "~> 1.4.0"},
      {:opentelemetry_phoenix, "~> 1.2.0"},
      {:opentelemetry_cowboy, "~> 0.3.0"},
      {:opentelemetry_exporter, "~> 1.7.0"},
      {:opentelemetry_ecto, "~> 1.2.0"}
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
