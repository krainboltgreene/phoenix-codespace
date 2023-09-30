defmodule Core.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Core.Content` context.
  """
  use ExMachina.Ecto, repo: Core.Repo

  @randomizer_mapper %{
    Core.Universes.Act => "Core.Randomizer.Act",
    Core.Universes.Adventure => "Core.Randomizer.Adventure",
    Core.Universes.Artifact => "Core.Randomizer.Artifact",
    Core.Universes.Culture => "Core.Randomizer.Culture",
    Core.Universes.CultureLanguage => "Core.Randomizer.CultureLanguage",
    Core.Universes.Deity => "Core.Randomizer.Deity",
    Core.Universes.Encounter => "Core.Randomizer.Encounter",
    Core.Universes.Government => "Core.Randomizer.Government",
    Core.Universes.Group => "Core.Randomizer.Group",
    Core.Universes.Identity => "Core.Randomizer.Identity",
    Core.Universes.Location => "Core.Randomizer.Location",
    Core.Universes.Pantheon => "Core.Randomizer.Pantheon",
    Core.Universes.Person => "Core.Randomizer.Person",
    Core.Universes.Room => "Core.Randomizer.Room",
    Core.Universes.Trap => "Core.Randomizer.Trap",
    Core.Universes.World => "Core.Randomizer.World"
  }

  def generation_factory() do
    %Core.Content.Generation{}
  end

  def with_generation_for([], _, _), do: []

  def with_generation_for(records, property, state) when is_list(records) do
    Enum.each(records, fn record -> with_generation_for(record, property, state) end)
  end

  def with_generation_for(record, property, state) do
    insert(:generation, %{
      resource_id: record.id,
      property: property,
      state: state,
      randomizer: @randomizer_mapper[record.__struct__],
      world_id: record.world_id
    })
  end

  def with_image_batches(context) do
    Map.put_new_lazy(
      context,
      :image_batches,
      fn ->
        [
          %Core.Content.ImageBatch{}
          |> Core.Content.ImageBatch.changeset(%{
            prompt: "A dog riding a horse"
          })
          |> Core.Repo.insert!()
          |> Core.Content.ImageBatch.changeset_for_images(%{
            images: [%Core.Content.Image{content: "aaa"}]
          })
          |> Core.Repo.update!()
        ]
      end
    )
  end

  def with_gpu_servers(context) do
    Map.put_new_lazy(
      context,
      :gpu_servers,
      fn ->
        [
          %Core.Content.GPUServer{}
          |> Core.Content.GPUServer.changeset(%{
            secret: "sssh",
            name: "aaa",
            origin: "http://localhost:4001",
            power: "off",
            busy: true
          })
          |> Core.Repo.insert!(),
          %Core.Content.GPUServer{}
          |> Core.Content.GPUServer.changeset(%{
            secret: "sssh",
            name: "bbb",
            origin: "http://localhost:4002",
            power: "starting-up",
            busy: true
          })
          |> Core.Repo.insert!(),
          %Core.Content.GPUServer{}
          |> Core.Content.GPUServer.changeset(%{
            secret: "sssh",
            name: "ccc",
            origin: "http://localhost:4003",
            power: "shutting-down",
            busy: true
          })
          |> Core.Repo.insert!(),
          %Core.Content.GPUServer{}
          |> Core.Content.GPUServer.changeset(%{
            secret: "sssh",
            name: "ddd",
            origin: "http://localhost:4004",
            power: "on",
            busy: true
          })
          |> Core.Repo.insert!()
        ]
      end
    )
  end
end
