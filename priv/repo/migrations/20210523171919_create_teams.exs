defmodule Jalka2021.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add(:name, :string, null: false)
      add(:flag, :string, null: false)
      add(:emoji, :string, null: false)
      add(:fifa_code, :string, null: false)
      add(:emoji_string, :string, null: false)
      timestamps()
    end

    create(index(:teams, [:id]))
  end
end
