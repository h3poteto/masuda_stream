import Config

if config_env() == :prod do
  config :masuda_stream, MasudaStreamWeb.Endpoint,
    http: [ip: {0, 0, 0, 0}, port: String.to_integer(System.get_env("PORT") || "4000")],
    secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

  config :rollbax,
    access_token: System.fetch_env!("ROLLBAR_ACCESS_TOKEN"),
    environment: "production",
    enable_crash_reports: true,
    enabled: true

  config :opentelemetry, :processors,
    otel_batch_processor: %{
      exporter:
        {:opentelemetry_exporter, %{endpoints: [System.fetch_env!("OTEL_EXPORTER_ENDPOINT")]}}
    }
end

config :ueberauth, Ueberauth.Strategy.Hatena.OAuth,
  consumer_key: System.fetch_env!("HATENA_CONSUMER_KEY"),
  consumer_secret: System.fetch_env!("HATENA_CONSUMER_SECRET"),
  scope: "read_public,write_public"

config :masuda_stream, MasudaStream.Repo,
  username: System.get_env("DB_USERNAME") || "postgres",
  password: System.get_env("DB_PASSWORD") || "",
  database: System.get_env("DB_NAME") || "masuda_stream",
  hostname: System.get_env("DB_HOSTNAME") || "postgres",
  show_sensitive_data_on_connection_error: true,
  pool_size: 8,
  queue_target: 5000
