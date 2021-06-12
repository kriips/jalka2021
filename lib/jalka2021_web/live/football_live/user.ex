defmodule Jalka2021Web.FootballLive.User do
  use Phoenix.LiveView

  alias Jalka2021Web.Resolvers.{FootballResolver, AccountsResolver}

  @impl true
  def mount(params, _session, socket) do
    {:ok,
      socket
      |> assign(
           predictions: FootballResolver.get_predictions_by_user(params["id"]) |> FootballResolver.add_correctness,
                                    user: AccountsResolver.get_user(params["id"]),
            playoff_predictions: FootballResolver.get_playoff_predictions_with_team_names(params["id"])
         )}
  end

  @impl true
  def render(assigns),
      do: Phoenix.View.render(Jalka2021Web.UserView, "user.html", assigns)
end
