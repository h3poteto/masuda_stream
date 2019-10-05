defmodule MasudaStream.Repo.Migrations.CreateHatenaEntryDetails do
  use Ecto.Migration

  def change do
    create table(:hatena_entry_details) do
      add :entry_id, references(:hatena_entries, on_delete: :nothing)
      add :eid, :string
      add :count, :integer
      add :url, :string
      add :title, :string
      add :screenshot, :string

      timestamps([type: :utc_datetime])
    end

  end
end
