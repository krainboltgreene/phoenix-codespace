defmodule CoreWeb.EncounterLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.DataFixtures
  import Core.UniversesFixtures
  import Core.ChallengesFixtures

  setup :register_and_log_in_account
  setup :with_worlds
  setup :set_world_as_tenant
  setup :set_current_world_in_session
  setup :with_name_options
  setup :with_encounters

  test "listing", %{conn: conn, encounters: records} do
    stub(Core.Job.GeneratePropertyJob, :generating?, fn _id, _property -> false end)
    stub(Core.Job.GeneratePropertyJob, :generating?, fn _id -> false end)

    {:ok, _view, html} =
      conn
      |> live("/worlds/encounters")

    assert with_element(html, "#page_title") =~ "Encounters"
    assert with_element(html, "button[phx-click='create']") =~ "Generate Encounter"

    for record <- records do
      assert with_element(html, "##{record.id}") =~
               Pretty.get(record, :title)
    end
  end

  test "details", %{conn: conn, encounters: [record | _]} do
    {:ok, _view, html} =
      conn
      |> live("/worlds/encounters/#{record.id}")

    assert with_element(html, "#page_title") =~
             "Encounter / #{Pretty.get(record, :title)} (#{record.rating / 100} CR)"
  end
end
