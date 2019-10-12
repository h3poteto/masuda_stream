defmodule MasudaStream.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :identifier, :string, null: false
      add :display_name, :string, null: false
      add :token, :string, null: false
      add :token_secret, :string, null: false
      add :icon, :string

      timestamps()
    end
  end
end
