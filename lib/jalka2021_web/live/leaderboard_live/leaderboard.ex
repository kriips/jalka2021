defmodule Jalka2021Web.LeaderboardLive.Leaderboard do
  use Phoenix.LiveView

  alias Jalka2021.Leaderboard
  alias Jalka2021Web.LiveHelpers
  alias Jalka2021.Football.{Match}

  @impl true
  def mount(params, session, socket) do
    socket = LiveHelpers.assign_defaults(session, socket)
    {:ok, assign(socket, leaderboard: Leaderboard.get_leaderboard())}
  end

  @impl true
  def render(assigns),
    do: Phoenix.View.render(Jalka2021Web.LeaderboardView, "leaderboard.html", assigns)
end
