defmodule MasudaStream.Anond do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime]

  schema "anonds" do
    belongs_to :entry, MasudaStream.Hatena.Entry
    field :content_html, :string

    timestamps()
  end

  @doc false
  def changeset(anond, attrs) do
    anond
    |> cast(attrs, [:content_html, :entry_id])
    |> validate_required([:entry_id])
    |> assoc_constraint(:entry)
  end
end
