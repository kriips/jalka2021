defmodule Jalka2021Web.UserRegistrationController do
  use Jalka2021Web, :controller

  alias Jalka2021.Accounts
  alias Jalka2021.Accounts.User
  alias Jalka2021Web.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Kasutaja loodud.")
        |> UserAuth.log_in_user(user)
        |> redirect(to: "/predict")

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> redirect(to: Routes.user_session_path(conn, :new))
    end
  end
end
