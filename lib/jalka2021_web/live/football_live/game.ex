defmodule Jalka2021Web.FootballLive.Game do
  use Phoenix.LiveView

  alias Jalka2021Web.Resolvers.FootballResolver

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(
       predictions: FootballResolver.get_predictions_by_match_result(params["id"]),
       match: FootballResolver.list_match(params["id"])
     )}
  end

  @impl true
  def render(assigns),
    do: Phoenix.View.render(Jalka2021Web.GamesView, "game.html", assigns)
end
