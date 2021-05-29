defmodule Jalka2021Web.UserPredictionLive.Groups do
  use Phoenix.LiveView

  alias Jalka2021Web.Router.Helpers, as: Routes
  alias Jalka2021Web.Resolvers.FootballResolver
  alias Jalka2021Web.LiveHelpers
  alias Jalka2021.Football.{GroupPrediction, Match}

  @impl true
  def mount(params, session, socket) do
    group = Map.get(params, "group")
    socket = LiveHelpers.assign_defaults(session, socket)

    predictions =
      FootballResolver.list_matches_by_group(group)
      |> Enum.map(fn match -> add_changeset(match, socket) end)

    # TODO: Remove this inspect
    IO.inspect(predictions)
    {:ok, assign(socket, group: group, predictions: predictions)}
  end

  @impl true
  def render(assigns),
    do: Phoenix.View.render(Jalka2021Web.PredictionView, "groups.html", assigns)

  defp add_changeset(%Match{} = match, socket) do
    changeset =
      GroupPrediction.create_changeset(
        %GroupPrediction{},
        %{
          user: socket.assigns.current_user.id,
          match: match.id
        }
      )

    {match, changeset}
  end
end
