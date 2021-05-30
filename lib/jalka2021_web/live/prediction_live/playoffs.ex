defmodule Jalka2021Web.UserPredictionLive.Playoffs do
  use Phoenix.LiveView

  alias Jalka2021Web.LiveHelpers

  @impl true
  def mount(_params, session, socket) do
    socket = LiveHelpers.assign_defaults(session, socket)
    {:ok, assign(socket, matches: %{})}
  end

  @impl true
  def render(assigns),
    do: Phoenix.View.render(Jalka2021Web.PredictionView, "playoffs.html", assigns)
end
