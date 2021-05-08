defmodule Jalka2021Web.UserRegistrationLive.New do
  use Phoenix.LiveView

  alias Jalka2021Web.Router.Helpers, as: Routes
  alias Jalka2021.Accounts
  alias Jalka2021.Accounts.User

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})
    {:ok, assign(socket, changeset: changeset)}
  end

  def render(assigns), do: Phoenix.View.render(Jalka2021Web.UserRegistrationView, "new.html", assigns)

  def handle_event("validate", %{"user" => user_params}, socket) do
    IO.inspect("validating") # TODO: Remove this inspect
    changeset =
      %User{}
      |> Jalka2021.Accounts.change_user_registration(user_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    IO.inspect("saving") # TODO: Remove this inspect
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(socket, :confirm, &1)
          )

        {:noreply,
          socket
          |> put_flash(:info, "Konto loodud. Kontrolli oma emaili selle õigsuse kinnitamiseks")
          |> redirect(to: Routes.user_session_path(socket, :new))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
