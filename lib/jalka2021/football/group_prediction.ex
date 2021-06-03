defmodule Jalka2021.Football.GroupPrediction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jalka2021.Repo

  schema "group_prediction" do
    belongs_to(:user, Jalka2021.Accounts.User)
    belongs_to(:match, Jalka2021.Football.Match)
    field(:home_score, :integer, default: 0)
    field(:away_score, :integer, default: 0)
    field(:result, :string)

    timestamps()
  end

  @doc false
  def changeset(group_prediction, attrs) do
    group_prediction
    |> cast(attrs, [:user, :match, :prediction])
  end

  def get_group_prediction!(id) do
    Repo.get!(GroupPrediction, id)
  end

  @doc false
  def create_changeset(group_prediction, attrs) do
    group_prediction
    |> cast(attrs, [:user_id, :match_id, :home_score, :away_score, :result])
    |> cast_assoc(:user)
    |> assoc_constraint(:user)
    |> cast_assoc(:match)
    |> assoc_constraint(:match)
  end
end
