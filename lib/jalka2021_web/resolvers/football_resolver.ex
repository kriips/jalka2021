defmodule Jalka2021Web.Resolvers.FootballResolver do
  alias Jalka2021.{Football}

  def list_matches_by_group(group) do
    Football.get_matches_by_group("Alagrupp #{group}")
  end

  def get_prediction(%{match_id: match_id, user_id: user_id}) do
    Football.get_prediction_by_user_match(user_id, match_id)
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
      away_score: away_score
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
end
