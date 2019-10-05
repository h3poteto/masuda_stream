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

    create unique_index(:hatena_entry_bookmarks, [:entry_detail_id, :user], :entry_bookmarks_on_entry_dtail_id_and_user_index)
  end
end
