defmodule MasudaStream.Hatena.EntryBookmark do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hatena_entry_bookmarks" do
    field :bookmarked_at, :utc_datetime
    field :comment, :string
    field :user, :string
    belongs_to :entry_detail, MasudaStream.Hatena.EntryDetail

    timestamps()
  end

  @doc false
  def changeset(entry_bookmark, attrs) do
    entry_bookmark
    |> cast(attrs, [:bookmarked_at, :comment, :user, :entry_detail_id])
    |> validate_required([:bookmarked_at, :comment, :user, :entry_detail_id])
    |> assoc_constraint(:entry_detail)
  end
end
