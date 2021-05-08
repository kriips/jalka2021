defmodule Jalka2021.Repo.Migrations.AddNameToUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    alter table(:users) do
      add :name, :citext, null: false
    end
  end
end
