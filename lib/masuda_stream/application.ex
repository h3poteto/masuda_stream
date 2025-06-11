defmodule MasudaStream.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    :opentelemetry_cowboy.setup()
    OpentelemetryPhoenix.setup(adapter: :cowboy2)
    OpentelemetryEcto.setup([:masuda_stream, :repo], [{:db_statement, :enabled}])

    # List all child processes to be supervised
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: MasudaStream.PubSub},
      # Start the Ecto repository
      MasudaStream.Repo,
      # Start the endpoint when the application starts
      MasudaStreamWeb.Endpoint,
      {Oban, Application.fetch_env!(:masuda_stream, Oban)},
      # Starts a worker by calling: MasudaStream.Worker.start_link(arg)
      # {MasudaStream.Worker, arg},
      MasudaStreamWeb.Telemetry
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MasudaStream.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MasudaStreamWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
