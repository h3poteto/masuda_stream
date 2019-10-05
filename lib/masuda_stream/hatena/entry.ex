defmodule MasudaStream.Hatena.Entry do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime]

  schema "hatena_entries" do
    field :title, :string
    field :summary, :string
    field :content, :string
    field :link, :string
    field :hatena_bookmarkcount, :integer
    field :posted_at, :utc_datetime
    has_one :anond, MasudaStream.Anond
    has_one :entry_detail, MasudaStream.Hatena.EntryDetail

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:title, :summary, :content, :link, :hatena_bookmarkcount, :posted_at])
    |> validate_required([:title, :link, :hatena_bookmarkcount, :posted_at])
  end
end
