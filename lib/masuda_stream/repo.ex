defmodule MasudaStream.Repo do
  use Ecto.Repo,
    otp_app: :masuda_stream,
    adapter: Ecto.Adapters.Postgres
end
