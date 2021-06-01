defmodule Jalka2021.Football.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jalka2021.Repo
  alias Jalka2021.Football.PlayoffPrediction

  schema "teams" do
    field(:name, :string)
    field(:code, :string)
    field(:flag, :string)
    field(:group, :string)

    many_to_many :playoff_predictions, PlayoffPrediction,
      join_through: "playoff_predictions_teams"

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :code, :flag, :id, :group])
  end

  def get_team!(id), do: Repo.get!(Team, id)
end
