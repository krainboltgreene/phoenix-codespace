defmodule Core.StoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Core.Stories` context.
  """

  def with_acts(context) do
    context
    |> with_adventures()
    |> then(fn %{adventures: [adventure | _]} = context ->
      context
      |> Map.put_new_lazy(:acts, fn ->
        [
          Core.Stories.create_act!(%{
            name: "Foos",
            adventure: adventure
          })
        ]
      end)
    end)
  end

  def with_adventures(context) do
    context
    |> Core.UniversesFixtures.with_people()
    |> then(fn %{people: [contract, agent | _]} = context ->
      context
      |> Map.put_new_lazy(:adventures, fn ->
        [
          Core.Stories.create_adventure!(%{
            name: "Duo",
            contract: contract,
            agent: agent
          })
        ]
      end)
    end)
  end
end
