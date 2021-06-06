defmodule Jalka2021.Football do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Jalka2021.Repo
  alias Jalka2021.Football.{Match, GroupPrediction, PlayoffPrediction, Team}

  ## Database getters

  def get_matches_by_group(group) when is_binary(group) do
    query =
      from m in Match,
        where: m.group == ^group,
        order_by: m.date,
        preload: [:home_team, :away_team]

    Repo.all(query)
  end

  def get_matches() do
    query =
      from m in Match,
        order_by: m.date,
        preload: [:home_team, :away_team]

    Repo.all(query)
  end

  def get_match(id) do
    Repo.get_by(Match, id: id) |> Repo.preload([:home_team, :away_team])
  end

  def get_prediction_by_user_match(user_id, match_id) do
    Repo.get_by(GroupPrediction, user_id: user_id, match_id: match_id)
  end

  def get_predictions_by_match(match_id) do
    query =
      from gp in GroupPrediction,
        where: gp.match_id == ^match_id,
        preload: [:user]

    Repo.all(query)
  end

  def get_predictions_by_user(user_id) do
    query =
      from gp in GroupPrediction,
        where: gp.user_id == ^user_id,
        preload: [:match]

    Repo.all(query)
  end

  def get_playoff_predictions() do
    query =
      from pp in PlayoffPrediction,
        preload: [:user, :team]

    Repo.all(query)
  end

  def get_playoff_predictions_by_user(user_id) do
    query =
      from pp in PlayoffPrediction,
        where: pp.user_id == ^user_id

    Repo.all(query)
  end

  def get_playoff_prediction_by_user_phase_team(user_id, phase, team_id) do
    Repo.get_by(PlayoffPrediction, user_id: user_id, team_id: team_id, phase: phase)
  end

  def delete_playoff_predictions_by_user_team(user_id, team_id, phase) do
    query =
      from pp in PlayoffPrediction,
        where: pp.user_id == ^user_id and pp.team_id == ^team_id and pp.phase <= ^phase

    Repo.delete_all(query)
  end

  def change_score(
        %{
          result: result,
          user_id: user_id,
          match_id: match_id,
          home_score: _home_score,
          away_score: _away_score
        } = attrs
      ) do
    case get_prediction_by_user_match(user_id, match_id) do
      %GroupPrediction{} = prediction ->
        prediction |> GroupPrediction.create_changeset(attrs) |> Repo.update!()

      nil ->
        %GroupPrediction{} |> GroupPrediction.create_changeset(attrs) |> Repo.insert!()
    end
  end

  def get_teams() do
    Team
    |> Repo.all()
  end

  def add_playoff_prediction(%{user_id: user_id, team_id: team_id, phase: phase} = attrs) do
    case get_playoff_prediction_by_user_phase_team(user_id, phase, team_id) do
      %PlayoffPrediction{} = prediction ->
        prediction |> PlayoffPrediction.create_changeset(attrs) |> Repo.update!()

      nil ->
        %PlayoffPrediction{} |> PlayoffPrediction.create_changeset(attrs) |> Repo.insert!()
    end
  end

  def remove_playoff_prediction(%{user_id: user_id, team_id: team_id, phase: phase}) do
    delete_playoff_predictions_by_user_team(user_id, team_id, phase)
  end
end
