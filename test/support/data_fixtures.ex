defmodule Core.DataFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Core.Data` context.
  """

  def with_name_options(context) do
    Core.Data
    |> Mimic.stub(:naming_onomastics, fn -> ["silly"] end)
    |> Mimic.stub(:list_name_options, fn ->
      [
        %{
          id: "example",
          tags: ["person", "names", "silly"],
          trigrams: [
            "^exa",
            "exam",
            "xamp",
            "ampl",
            "mple",
            "ple$",
            "^ex",
            "exa",
            "xam",
            "amp",
            "mpl",
            "ple",
            "le$",
            "^e",
            "ex",
            "xa",
            "am",
            "mp",
            "pl",
            "le",
            "e$"
          ]
        }
      ]
    end)
    |> Mimic.stub(:random_name_option, fn ->
      %{
        id: "example",
        tags: ["person", "names", "silly"],
        trigrams: [
          "^exa",
          "exam",
          "xamp",
          "ampl",
          "mple",
          "ple$",
          "^ex",
          "exa",
          "xam",
          "amp",
          "mpl",
          "ple",
          "le$",
          "^e",
          "ex",
          "xa",
          "am",
          "mp",
          "pl",
          "le",
          "e$"
        ]
      }
    end)

    context
    |> Map.put(:name_options, Core.Data.list_name_options())
  end

  def with_baseline_data(context) do
    context
  end

  def with_archetype_options(context) do
    context
    |> Map.put(:archetype_options, Core.Data.list_archetype_options())
  end

  def with_asset_options(context) do
    context
    |> Map.put(:asset_options, Core.Data.list_asset_options())
  end

  def with_background_options(context) do
    context
    |> Map.put(:background_options, Core.Data.list_background_options())
  end

  def with_cultural_art_options(context) do
    context
    |> Map.put(:cultural_art_options, Core.Data.list_cultural_art_options())
  end

  def with_cultural_ethos_options(context) do
    context
    |> Map.put(
      :cultural_ethos_options,
      Core.Data.list_cultural_ethos_options()
    )
  end

  def with_cultural_gender_preference_options(context) do
    context
    |> Map.put(
      :cultural_gender_preference_options,
      Core.Data.list_cultural_gender_preference_options()
    )
  end

  def with_cultural_phase_options(context) do
    context
    |> Map.put(
      :cultural_phase_options,
      Core.Data.list_cultural_phase_options()
    )
  end

  def with_cultural_pillar_options(context) do
    context
    |> Map.put(
      :cultural_pillar_options,
      Core.Data.list_cultural_pillar_options()
    )
  end

  def with_cultural_scale_options(context) do
    context
    |> Map.put(
      :cultural_scale_options,
      Core.Data.list_cultural_scale_options()
    )
  end

  def with_cultural_society_options(context) do
    context
    |> Map.put(
      :cultural_society_options,
      Core.Data.list_cultural_society_options()
    )
  end

  def with_encounter_context_options(context) do
    context
    |> Map.put(
      :encounter_context_options,
      Core.Data.list_encounter_context_options()
    )
  end

  def with_gender_identity_options(context) do
    context
    |> Map.put(
      :gender_identity_options,
      Core.Data.list_gender_identity_options()
    )
  end

  def with_gender_presentation_options(context) do
    context
    |> Map.put(
      :gender_presentation_options,
      Core.Data.list_gender_presentation_options()
    )
  end

  def with_group_age_options(context) do
    context
    |> Map.put(:group_age_options, Core.Data.list_group_age_options())
  end

  def with_group_goal_options(context) do
    context
    |> Map.put(:group_goal_options, Core.Data.list_group_goal_options())
  end

  def with_group_scope_options(context) do
    context
    |> Map.put(:group_scope_options, Core.Data.list_group_scope_options())
  end

  def with_group_size_options(context) do
    context
    |> Map.put(:group_size_options, Core.Data.list_group_size_options())
  end

  def with_location_development_options(context) do
    context
    |> Map.put(
      :location_development_options,
      Core.Data.list_location_development_options()
    )
  end

  def with_location_embellishment_options(context) do
    context
    |> Map.put(
      :location_embellishment_options,
      Core.Data.list_location_embellishment_options()
    )
  end

  def with_location_founding_options(context) do
    context
    |> Map.put(
      :location_founding_options,
      Core.Data.list_location_founding_options()
    )
  end

  def with_monster(context) do
    context
    |> Map.put(:monster, context.monsters |> Enum.random())
  end

  def with_monsters(context) do
    context
    |> Map.put(:monsters, Core.Data.list_monsters())
  end

  def with_objective_options(context) do
    context
    |> Map.put(:objective_options, Core.Data.list_objective_options())
  end

  def with_person_appearance_options(context) do
    context
    |> Map.put(
      :person_appearance_options,
      Core.Data.list_person_appearance_options()
    )
  end

  def with_person_role_options(context) do
    context
    |> Map.put(:person_role_options, Core.Data.list_person_role_options())
  end

  def with_person_type_options(context) do
    context
    |> Map.put(:person_type_options, Core.Data.list_person_type_options())
  end

  def with_race_options(context) do
    context
    |> Map.put(:race_options, Core.Data.list_race_options())
  end

  def with_religion_value_options(context) do
    context
    |> Map.put(
      :religion_value_options,
      Core.Data.list_religion_value_options()
    )
  end

  def with_room_detail_options(context) do
    context
    |> Map.put(:room_detail_options, Core.Data.list_room_detail_options())
  end

  def with_trait_options(context) do
    context
    |> Map.put(:trait_options, Core.Data.list_trait_options())
  end

  def with_trap_bait_options(context) do
    context
    |> Map.put(:trap_bait_options, Core.Data.list_trap_bait_options())
  end

  def with_trap_effect_options(context) do
    context
    |> Map.put(:trap_effect_options, Core.Data.list_trap_effect_options())
  end

  def with_trap_lethality_options(context) do
    context
    |> Map.put(
      :trap_lethality_options,
      Core.Data.list_trap_lethality_options()
    )
  end

  def with_trap_location_options(context) do
    context
    |> Map.put(:trap_location_options, Core.Data.list_trap_location_options())
  end

  def with_trap_purpose_options(context) do
    context
    |> Map.put(:trap_purpose_options, Core.Data.list_trap_purpose_options())
  end

  def with_trap_reset_options(context) do
    context
    |> Map.put(:trap_reset_options, Core.Data.list_trap_reset_options())
  end

  def with_trap_trigger_options(context) do
    context
    |> Map.put(:trap_trigger_options, Core.Data.list_trap_trigger_options())
  end

  def with_trap_type_options(context) do
    context
    |> Map.put(:trap_type_options, Core.Data.list_trap_type_options())
  end

  def with_person_goal_options(context) do
    context
    |> Map.put(:person_goal_options, Core.Data.list_person_goal_options())
  end

  def with_word_options(context) do
    context
    |> Map.put(:word_options, Core.Data.list_word_options())
  end
end
