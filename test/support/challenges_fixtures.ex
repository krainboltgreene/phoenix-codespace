defmodule Core.ChallengesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Core.Challenges` context.
  """

  def with_encounters(context) do
    context
    |> Core.DataFixtures.with_monsters()
    |> with_traps()
    |> with_rooms()
    |> then(fn %{rooms: [room | _], monsters: [monster | _], traps: [trap | _]} = context ->
      context
      |> Map.put_new_lazy(:encounters, fn ->
        [
          Core.Challenges.create_encounter!(%{
            rating: 1000,
            room: room,
            traps: [trap],
            monsters: [monster]
          })
        ]
      end)
    end)
  end

  def with_rooms(context) do
    context
    |> Map.put_new_lazy(:rooms, fn ->
      [
        Core.Challenges.create_room!(%{
          type: "dungeon",
          specific: "Mine Shaft"
        })
      ]
    end)
  end

  def with_traps(context) do
    context
    |> Map.put_new_lazy(:traps, fn -> [Core.Challenges.create_trap!(%{})] end)
  end
end
