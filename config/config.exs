# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :masuda_stream,
  ecto_repos: [MasudaStream.Repo]

# Configures the endpoint
config :masuda_stream, MasudaStreamWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kUCaoCJeP4WmicXwDkg0bhj2eEp/RPv72TNLarha+ID96vprDzd+1+gGMdUwOmaf",
  render_errors: [view: MasudaStreamWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: MasudaStream.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :floki, :html_parser, Floki.HTMLParser.Html5ever

config :ueberauth, Ueberauth,
  providers: [
    hatena: {Ueberauth.Strategy.Hatena, []}
  ]

config :rollbax, enabled: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
