defmodule MasudaStream.User do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime]

  schema "users" do
    field :display_name, :string
    field :identifier, :string
    field :token, :string
    field :token_secret, :string
    field :icon, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:identifier, :display_name, :token, :token_secret, :icon])
    |> validate_required([:identifier, :display_name, :token, :token_secret])
  end
end
