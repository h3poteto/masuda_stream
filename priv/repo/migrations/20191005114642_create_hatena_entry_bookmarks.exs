defmodule MasudaStream.Repo.Migrations.CreateHatenaEntryBookmarks do
  use Ecto.Migration

  def change do
    create table(:hatena_entry_bookmarks) do
      add :entry_detail_id, references(:hatena_entry_details, on_delete: :nothing)
      add :bookmarked_at, :utc_datetime
      add :comment, :string
      add :user, :string

      timestamps([type: :utc_datetime])
    end

  end
end
