defmodule Jalka2021.Football do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Jalka2021.Repo
  alias Jalka2021.Football.{Match}

  ## Database getters

  def get_matches_by_group(group) when is_binary(group) do
    query =
      from m in Match,
        where: m.group == ^group,
        order_by: m.date,
        preload: [:home_team, :away_team]

    Repo.all(query)
  end
end
