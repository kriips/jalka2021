defmodule Jalka2021Web.LeaderboardLive.Leaderboard do
  use Phoenix.LiveView

  alias Jalka2021.Leaderboard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, leaderboard: Leaderboard.get_leaderboard())}
  end

  @impl true
  def render(assigns),
    do: Phoenix.View.render(Jalka2021Web.LeaderboardView, "leaderboard.html", assigns)
end
