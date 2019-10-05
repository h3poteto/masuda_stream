defmodule MasudaStream.Repo.Migrations.CreateAnonds do
  use Ecto.Migration

  def change do
    create table(:anonds) do
      add :entry_id, references(:hatena_entries, on_delete: :nothing)
      add :content_html, :text

      timestamps([type: :utc_datetime])
    end

  end
end
