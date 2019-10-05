defmodule MasudaStream.Hatena.EntryDetail do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hatena_entry_details" do
    field :count, :integer
    field :eid, :string
    field :screenshot, :string
    field :title, :string
    field :url, :string
    belongs_to :entry, MasudaStream.Hatena.Entry
    has_many :entry_bookmarks, MasudaStream.Hatena.EntryBookmark

    timestamps()
  end

  @doc false
  def changeset(entry_detail, attrs) do
    entry_detail
    |> cast(attrs, [:eid, :count, :url, :title, :screenshot, :entry_id])
    |> validate_required([:eid, :count, :url, :title, :screenshot, :entry_id])
    |> assoc_constraint(:entry)
  end
end
