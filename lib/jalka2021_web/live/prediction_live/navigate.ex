defmodule Jalka2021Web.UserPredictionLive.Navigate do
  use Phoenix.LiveView

  alias Jalka2021Web.Resolvers.FootballResolver
  alias Jalka2021Web.LiveHelpers

  @impl true
  def mount(_params, session, socket) do
    socket = LiveHelpers.assign_defaults(session, socket)
    filled_predictions = FootballResolver.filled_predictions(socket.assigns.current_user.id)

    progress = count_progress(filled_predictions)
    {:ok, assign(socket, filled: map_style(filled_predictions), progress: progress)}
  end

  @impl true
  def render(assigns),
    do: Phoenix.View.render(Jalka2021Web.PredictionView, "navigate.html", assigns)

  defp map_style(filled_predictions) do
    filled_predictions
    |> Enum.map(fn {group, count} ->
      if count != 6 do
        {group, "button-outline"}
      else
        {group, ""}
      end
    end)
    |> Enum.into(%{})
  end

  defp count_progress(filled_predictions) do
    progress =
      filled_predictions
      |> Enum.reduce(0, fn {_group, count}, acc ->
        acc + count
      end)

    progress * 100 / 63
  end
end
