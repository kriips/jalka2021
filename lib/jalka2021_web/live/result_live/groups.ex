defmodule Jalka2021Web.ResultLive.Groups do
  use Phoenix.LiveView

  alias Jalka2021Web.Resolvers.FootballResolver
  alias Jalka2021Web.LiveHelpers
  alias Jalka2021.Football.{Match}

  @impl true
  def mount(params, session, socket) do
    socket = LiveHelpers.assign_defaults(session, socket)
    {:ok, socket}
  end

  @impl true
  def render(assigns),
    do: Phoenix.View.render(Jalka2021Web.ResultView, "groups.html", assigns)

  @impl true
  def handle_event("save", values, socket) do
    FootballResolver.update_match(values["result"])
    {:noreply, socket}
  end
end
