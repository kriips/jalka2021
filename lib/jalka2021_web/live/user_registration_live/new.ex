defmodule Jalka2021Web.UserRegistrationLive.New do
  use Phoenix.LiveView

  alias Jalka2021Web.Router.Helpers, as: Routes
  alias Jalka2021.Accounts
  alias Jalka2021.Accounts.User
  alias Jalka2021Web.Resolvers.AccountsResolver

  defp search(query) do
    AccountsResolver.list_allowed_users(query)
    |> Enum.map(fn user ->
      user_map =  Map.from_struct(user)
      {user.id, user.name}
    end)
    |> Enum.slice(0, 10)
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})
    {:ok, assign(socket, changeset: changeset, query: "", results: %{})}
  end

  @impl true
  def render(assigns), do: Phoenix.View.render(Jalka2021Web.UserRegistrationView, "new.html", assigns)

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
     changeset =
       %User{}
        |> Jalka2021.Accounts.change_user_registration(user_params)
        |> Map.put(:action, :insert)

    {:noreply, assign(socket, results: search(user_params["name"]), query: user_params["name"], changeset: changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    IO.inspect("saving") # TODO: Remove this inspect
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:noreply,
          socket
          |> put_flash(:info, "Konto loodud")
          |> redirect(to: Routes.prediction_path(socket, :edit))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
