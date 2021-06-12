defmodule Jalka2021Web.Resolvers.FootballResolver do
  alias Jalka2021.{Football}

  def list_matches_by_group(group) do
    Football.get_matches_by_group("Alagrupp #{group}")
  end

  def list_matches() do
    Football.get_matches()
  end

  def list_finished_matches() do
    Football.get_finished_matches()
  end

  def list_match(id) do
    Football.get_match(id)
  end

  def update_match(%{"away_score" => away_score, "home_score" => home_score, "game_id" => game_id}) do
    Football.update_match_score(
      String.to_integer(game_id),
      String.to_integer(home_score),
      String.to_integer(away_score)
    )

    Jalka2021.Leaderboard.recalc_leaderboard()
  end

  def get_prediction(%{match_id: match_id, user_id: user_id}) do
    Football.get_prediction_by_user_match(user_id, match_id)
  end

  def get_predictions_by_match_result(match_id) do
    Football.get_predictions_by_match(match_id)
    |> group_by_result()
  end

  def change_prediction_score(%{
        match_id: match_id,
        user_id: user_id,
        score: {home_score, away_score}
      }) do
    Football.change_score(%{
      user_id: user_id,
      match_id: match_id,
      home_score: home_score,
      away_score: away_score,
      result: calculate_result(home_score, away_score)
    })
  end

  def change_playoff_prediction(%{
        user_id: user_id,
        team_id: team_id,
        phase: phase,
        include: include
      }) do
    if include do
      Football.add_playoff_prediction(%{
        user_id: user_id,
        team_id: team_id,
        phase: phase
      })
    else
      Football.remove_playoff_prediction(%{
        user_id: user_id,
        team_id: team_id,
        phase: phase
      })
    end
  end

  def get_teams_by_group() do
    teams = %{
      "A" => [],
      "B" => [],
      "C" => [],
      "D" => [],
      "E" => [],
      "F" => []
    }

    Football.get_teams()
    |> Enum.reduce(teams, fn team, acc ->
      group = team.group
      Map.put(acc, group, [{team.id, team.name} | acc[group]])
    end)
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

    Football.get_predictions_by_user(user_id)
    |> Enum.reduce(user_predictions, fn prediction, acc ->
      group = prediction.match.group
      Map.put(acc, group, acc[group] + 1)
    end)
  end

  def get_playoff_predictions(user_id) do
    user_playoff_predictions = %{
      16 => [],
      8 => [],
      4 => [],
      2 => [],
      1 => []
    }

    Football.get_playoff_predictions_by_user(user_id)
    |> Enum.reduce(user_playoff_predictions, fn prediction, acc ->
      Map.put(acc, prediction.phase, [prediction.team_id | acc[prediction.phase]])
    end)
  end

  def get_playoff_predictions() do
    Football.get_playoff_predictions()
    |> group_by_phase()
    |> group_by_team()
    |> sort_by_count()
    |> sort_by_phase()
  end

  def calculate_result(home_score, away_score) do
    cond do
      home_score > away_score -> "home"
      home_score < away_score -> "away"
      home_score == away_score -> "draw"
    end
  end

  defp group_by_result(predictions) do
    predictions
    |> Enum.group_by(& &1.result, & &1)
  end

  defp group_by_phase(predictions) do
    playoff_predictions = %{
      1 => [],
      2 => [],
      4 => [],
      8 => [],
      16 => []
    }

    predictions
    |> Enum.reduce(playoff_predictions, fn prediction, acc ->
      Map.put(acc, prediction.phase, [
        %{team_name: prediction.team.name, user_name: prediction.user.name}
        | acc[prediction.phase]
      ])
    end)
  end

  defp group_by_team(predictions) do
    predictions
    |> Enum.map(fn {phase, user_prediction} ->
      {phase, Enum.group_by(user_prediction, & &1.team_name, & &1.user_name) |> Map.to_list()}
    end)
  end

  defp sort_by_count(predictions) do
    predictions
    |> Enum.map(fn {phase, user_predictions} ->
      {
        phase,
        user_predictions
        |> Enum.sort(fn {_team_name1, users1}, {_team_name2, users2} ->
          Enum.count(users1) >= Enum.count(users2)
        end)
      }
    end)
  end

  defp sort_by_phase(predictions) do
    predictions
    |> Enum.sort(fn {phase1, _pred1}, {phase2, _pred2} ->
      phase1 >= phase2
    end)
  end
end
