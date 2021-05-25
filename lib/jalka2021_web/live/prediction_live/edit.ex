defmodule Jalka2021Web.UserPredictionLive.Edit do
  use Phoenix.LiveView

  alias Jalka2021Web.Router.Helpers, as: Routes
  alias Jalka2021.Accounts
  alias Jalka2021.Accounts.User
  alias Jalka2021Web.Resolvers.AccountsResolver

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, matches: %{})}
  end

  @impl true
  def render(assigns), do: Phoenix.View.render(Jalka2021Web.PredictionView, "edit.html", assigns)
end
