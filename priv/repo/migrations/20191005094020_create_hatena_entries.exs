defmodule MasudaStream.Repo.Migrations.CreateHatenaEntries do
  use Ecto.Migration

  def change do
    create table(:hatena_entries) do
      add :identifier, :string, null: false
      add :title, :string, null: false
      add :summary, :text
      add :content, :text
      add :link, :string, null: false
      add :hatena_bookmarkcount, :integer, null: false, default: 0
      add :posted_at, :utc_datetime, null: false

      timestamps([type: :utc_datetime])
    end

    create unique_index(:hatena_entries, [:identifier])
  end
end
