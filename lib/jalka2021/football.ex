defmodule Jalka2021.Football do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Jalka2021.Repo
  alias Jalka2021.Football.{Match, GroupPrediction}

  ## Database getters

  def get_matches_by_group(group) when is_binary(group) do
    query =
      from m in Match,
        where: m.group == ^group,
        order_by: m.date,
        preload: [:home_team, :away_team]

    Repo.all(query)
  end

  def get_prediction_by_user_match(user_id, match_id) do
    Repo.get_by(GroupPrediction, user_id: user_id, match_id: match_id)
  end

  def get_predictions_by_user(user_id) do
    query =
      from gp in GroupPrediction,
        where: gp.user_id == ^user_id,
        preload: [:match]

    Repo.all(query)
  end

  def change_score(
        %{user_id: user_id, match_id: match_id, home_score: _home_score, away_score: _away_score} =
          attrs
      ) do
    case get_prediction_by_user_match(user_id, match_id) do
      %GroupPrediction{} = prediction ->
        prediction |> GroupPrediction.create_changeset(attrs) |> Repo.update!()

      nil ->
        %GroupPrediction{} |> GroupPrediction.create_changeset(attrs) |> Repo.insert!()
    end
  end

  def filled_predictions(user_id) do
    user_predictions = %{
      "Alagrupp A" => 0,
      "Alagrupp B" => 0,
      "Alagrupp C" => 0,
      "Alagrupp D" => 0,
      "Alagrupp E" => 0,
      "Alagrupp F" => 0
    }

    get_predictions_by_user(user_id)
    |> Enum.reduce(user_predictions, fn prediction, acc ->
      group = prediction.match.group
      Map.put(acc, group, acc[group] + 1)
    end)
  end
end
