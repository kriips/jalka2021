defmodule Jalka2021Web.Resolvers.AccountsResolver do
  alias Jalka2021.{Accounts, Repo}
  alias Accounts.{User, AllowedUser}

  def list_users() do
    User
    |> Repo.all
  end

  def list_allowed_users(query) do
    Jalka2021.Accounts.get_allowed_users_by_name(query)
  end

  def find_user(_parent, %{id: id}, _resolution) do
    case Jalka2021.Accounts.get_user!(id) do
      nil ->
        {:error, "User ID #{id} not found"}
      user ->
        {:ok, user}
    end
  end

  def current_user(_, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def current_user(_, _) do
    {:ok, nil}
  end
#
#  def register_user(args, _) do`
#    case Jalka2021.Accounts.register_user(args) do
#      {:ok, user} ->
#        {:ok, %{user: user}}
#
#      {:error, errors} ->
#        {:error, errors |> process_errors}
#    end
#  end

#  def login_user(%{name: name, password: password}, _) do
#    with user <- Accounts.get_user_by_name(name),
#         {:ok, user} <- Comeonin.Bcrypt.check_pass(user, password),
#         {:ok, token, _} <- Pokedex.Guardian.encode_and_sign(user) do
#      {:ok, %{user: user, token: token}}
#    else
#      _ -> {:error, "Valed andmed"}
#    end
#  end

end
