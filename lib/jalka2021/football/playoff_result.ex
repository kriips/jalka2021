defmodule Jalka2021.Football.PlayoffResult do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jalka2021.Football.Team
  alias Jalka2021.Repo

  schema "playoff_results" do
    belongs_to(:team, Team)
    field(:phase, :integer)

    timestamps()
  end

  @doc false
  def changeset(playoff_result, attrs) do
    playoff_result
    |> cast(attrs, [:phase, :team])
  end

  def get_playoff_result!(id) do
    Repo.get!(PlayoffResult, id)
  end

  @doc false
  def create_changeset(playoff_result, attrs) do
    playoff_result
    |> cast(attrs, [:team_id, :phase])
    |> cast_assoc(:team)
    |> assoc_constraint(:team)
  end
end
