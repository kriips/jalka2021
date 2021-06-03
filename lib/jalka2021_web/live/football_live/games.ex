defmodule Jalka2021Web.FootballLive.Games do
  use Phoenix.LiveView

  alias Jalka2021Web.Resolvers.FootballResolver
  alias Jalka2021Web.LiveHelpers

  @impl true
  def mount(_params, session, socket) do
    socket = LiveHelpers.assign_defaults(session, socket)
    matches = FootballResolver.list_matches()
    {:ok, assign(socket, matches: matches)}
  end

  @impl true
  def render(assigns),
    do: Phoenix.View.render(Jalka2021Web.GamesView, "games.html", assigns)
end
