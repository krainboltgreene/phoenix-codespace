defmodule Core.UniversesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Core.Universes` context.
  """
  use ExMachina.Ecto, repo: Core.Repo

  def set_world_as_tenant(%{worlds: [%{id: id} = world | _]} = context) do
    Utilities.put_world_id(id)

    context
    |> Map.put(:world, world)
  end

  def world_factory() do
    %Core.Universes.World{
      name: "Xa"
    }
  end

  def with_worlds(%{account: %{organizations: [organization | _]}} = context) do
    context
    |> Map.put_new_lazy(:worlds, fn ->
      [
        insert(:world, %{organization: organization})
      ]
    end)
  end

  def reverse_associate_worlds(context) do
    context
    |> Map.put(:account, context[:account] |> Map.put(:worlds, context[:worlds]))
  end

  def location_factory() do
    %Core.Universes.Location{
      name: "Torsoc",
      type: "dungeon"
    }
  end

  def with_locations(context) do
    context
    |> Map.put_new_lazy(:locations, fn ->
      [
        insert(:location, %{world: context.world})
      ]
    end)
  end

  def culture_factory() do
    %Core.Universes.Culture{
      name: "Sao"
    }
  end

  def with_cultures(context) do
    context
    |> Map.put_new_lazy(:cultures, fn ->
      [
        insert(:culture, %{world: context.world})
      ]
    end)
  end

  def religion_factory() do
    %Core.Universes.Religion{
      name: "Fra"
    }
  end

  def with_religions(context) do
    context
    |> Map.put_new_lazy(:religions, fn ->
      [
        insert(:religion, %{world: context.world})
      ]
    end)
  end

  def pantheon_factory() do
    %Core.Universes.Pantheon{
      name: "Eso"
    }
  end

  def with_pantheons(context) do
    context
    |> Map.put_new_lazy(:pantheons, fn ->
      [
        insert(:pantheon, %{world: context.world})
      ]
    end)
  end

  def with_deities(context) do
    context
    |> with_pantheons()
    |> with_cultures()
    |> with_religions()
    |> then(fn %{pantheons: [pantheon | _], cultures: [culture | _], religions: [religion | _]} =
                 context ->
      context
      |> Map.put_new_lazy(:deities, fn ->
        [
          %Core.Universes.Deity{
            person: build(:person, %{culture: culture, religion: religion, world: context.world}),
            pantheon: pantheon
          }
        ]
      end)
    end)
  end

  def government_factory() do
    %Core.Universes.Government{
      name: "Gre"
    }
  end

  def with_governments(context) do
    context
    |> Map.put_new_lazy(:governments, fn ->
      [
        insert(:government, %{world: context.world})
      ]
    end)
  end

  def group_factory() do
    %Core.Universes.Group{
      name: "Fos",
      size: "small",
      age: "new",
      scope: "neighborhood",
      headquarters: %{
        city: "Ick",
        district_type: "temple",
        neighborhood_type: "neighborhood",
        region_name: "Isl",
        region_type: "peninsula"
      }
    }
  end

  def with_groups(context) do
    context
    |> Map.put_new_lazy(:groups, fn ->
      [
        insert(:group, %{
          world: context.world,
          founders: [build(:person, %{world: context.world})],
          figureheads: [build(:person, %{world: context.world})]
        })
      ]
    end)
  end

  def identity_factory() do
    %Core.Universes.Identity{
      name: "Fas",
      titles: ["The Bloody"]
    }
  end

  def person_factory() do
    %Core.Universes.Person{
      archetype_option: Core.Data.random_archetype_option(),
      race: sequence(:race, ["elf", "human", "tiefling"]),
      role: sequence(:role, ["antagonist"]),
      gender_presentation: sequence(:role, ["masculine"]),
      background: background_factory(),
      appearance: appearance_factory(),
      objective: objective_factory(),
      identities: []
    }
  end

  def objective_factory() do
    %{
      long_form: "enact a chaotic plan only they can understand",
      method: "destabilize an enemy government",
      name: "mayhem",
      tags: ["politics", "war"]
    }
  end

  def appearance_factory() do
    %{
      age: "an elderly",
      body_type: "a stout",
      eye_color: "Yellow",
      facial_structure: "Wide Oblong",
      jaw_shape: "a clenched jaw",
      skin_modifier: "pale",
      skin_tone: "Terra-cotta"
    }
  end

  def background_factory() do
    %{
      languages: [],
      bond:
        "A crimelord I once worked for isn't happy I left the game, and their enforcers are looking for me.",
      flaw:
        "I am always broke... and when I'm not, I try to not spend my own money. But you can loan me a little, right? I've got a sure thing...",
      goals: ["missing value"],
      ideal:
        "having an edge. Knowledge is power, and knowing which mark has the most cash is as critical as winning.",
      name: "Gambler",
      origin:
        "How did I end up as a Gambler? One of my grandparents liked to gamble, and my childhood was spent playing games of chance with them. As I became an adult, I realized I could make a living off of it.",
      personality:
        "All that is certain in this world is chaos and chance. Therefor, planning is a fools's pastime.",
      proficiencies: ["Insight", "Deception"],
      special:
        "What is my gambling specialty? I run street games, like wheres-the-queen and skull-and-bones."
    }
  end

  def with_people(context) do
    context
    |> with_cultures()
    |> with_religions()
    |> then(fn %{cultures: [culture | _], religions: [religion | _]} = context ->
      context
      |> Map.put_new_lazy(:people, fn ->
        [
          insert(:person, %{
            culture: culture,
            religion: religion,
            world: context.world,
            identities: [
              build(:identity, %{world: context.world})
            ]
          })
        ]
      end)
    end)
  end

  def artifact_factory() do
    %Core.Universes.Artifact{
      name: "Cas"
    }
  end

  def with_artifacts(context) do
    context
    |> Map.put_new_lazy(:artifacts, fn ->
      [
        insert(:artifact, %{world: context.world})
      ]
    end)
  end

  def language_factory() do
    %Core.Universes.Language{
      name: "Fod"
    }
  end

  def with_languages(context) do
    context
    |> Map.put_new_lazy(:languages, fn ->
      [
        insert(:language, %{world: context.world})
      ]
    end)
  end
end
