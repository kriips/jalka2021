defmodule Jalka2021Web.Resolvers.FootballResolver do
  alias Jalka2021.{Football, Repo}
  alias Football.{Match}

  def list_matches_by_group(group) do
    Football.get_matches_by_group("Alagrupp #{group}")
  end
end
