# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Jalka2021.Repo.insert!(%Jalka2021.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

if Code.ensure_compiled?(Jalka2021.Accounts.AllowedUser) &&
     Jalka2021.Accounts.AllowedUser |> Jalka2021.Repo.aggregate(:count, :id) == 0 do
  Enum.each(Jason.decode!(File.read!('priv/repo/data/allowed_users.json')), fn attrs ->
    %Jalka2021.Accounts.AllowedUser{}
    |> Jalka2021.Accounts.AllowedUser.changeset(attrs)
    |> Jalka2021.Repo.insert!()
  end)
end

if Code.ensure_compiled?(Jalka2021.Football.Team) &&
     Jalka2021.Football.Team |> Jalka2021.Repo.aggregate(:count, :id) == 0 do
  Enum.each(Jason.decode!(File.read!('priv/repo/data/teams.json')), fn attrs ->
    # TODO: Remove this inspect
    IO.inspect(attrs)

    %Jalka2021.Football.Team{}
    |> Jalka2021.Football.Team.changeset(attrs)
    |> Jalka2021.Repo.insert!()
  end)
end

if Code.ensure_compiled?(Jalka2021.Football.Match) &&
     Jalka2021.Football.Match |> Jalka2021.Repo.aggregate(:count, :id) == 0 do
  Enum.each(Jason.decode!(File.read!('priv/repo/data/matches.json')), fn attrs ->
    # TODO: Remove this inspect
    IO.inspect(attrs)

    %Jalka2021.Football.Match{}
    |> Jalka2021.Football.Match.changeset(%{
      group: Map.get(attrs, "group"),
      home_team_id: Kernel.get_in(attrs, ["homeTeam", "id"]),
      away_team_id: Kernel.get_in(attrs, ["awayTeam", "id"]),
      date: Map.get(attrs, "utcDate")
    })
    |> Jalka2021.Repo.insert!()
  end)
end
