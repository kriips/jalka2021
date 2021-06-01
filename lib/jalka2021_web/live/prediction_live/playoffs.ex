defmodule Jalka2021Web.UserPredictionLive.Playoffs do
  use Phoenix.LiveView

  alias Jalka2021Web.Resolvers.FootballResolver
  alias Jalka2021Web.LiveHelpers

  @impl true
  def mount(_params, session, socket) do
    socket = LiveHelpers.assign_defaults(session, socket)
    predictions = FootballResolver.get_playoff_predictions(socket.assigns.current_user.id)

    {:ok,
     assign(socket,
       teams16: FootballResolver.get_teams_by_group() |> add_predictions(predictions, 16)
     )}
  end

  @impl true
  def render(assigns),
    do: Phoenix.View.render(Jalka2021Web.PredictionView, "playoffs.html", assigns)

  @impl true
  def handle_event("toggle-team", user_params, socket) do
    changed_prediction =
      FootballResolver.change_playoff_prediction(%{
        user_id: socket.assigns.current_user.id,
        team_id: String.to_integer(user_params["team"]),
        phase: String.to_integer(user_params["phase"]),
        include: user_params["value"] == "on"
      })

    {:noreply, socket}
  end

  defp add_predictions(teams_with_group, predictions, phase) do
    teams_with_group
    |> Enum.map(fn {group, teams} ->
      teams =
        Enum.map(teams, fn {id, name} ->
          if Enum.member?(predictions[phase], id) do
            {id, name, "checked"}
          else
            {id, name, ""}
          end
        end)

      {group, teams}
    end)
  end
end
