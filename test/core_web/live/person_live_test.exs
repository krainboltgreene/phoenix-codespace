defmodule CoreWeb.PersonLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.DataFixtures
  import Core.UniversesFixtures
  import Core.ContentFixtures

  setup :register_and_log_in_account
  setup :with_worlds
  setup :set_world_as_tenant
  setup :set_current_world_in_session
  setup :with_name_options
  setup :with_people

  test "listing", %{conn: conn, people: records} do
    with_generation_for(records, "name", false)
    with_generation_for(records, "identities", false)

    {:ok, _view, html} =
      conn
      |> live("/worlds/people")

    assert with_element(html, "#page_title") =~ "People"
    assert with_element(html, "button[phx-click='create']") =~ "Generate Person"

    for record <- Core.Repo.preload(records, identities: []) do
      assert with_element(html, "##{record.id}") =~
               Pretty.get(record, :name)
    end
  end

  test "details", %{conn: conn, people: [record | _]} do
    record = Core.Repo.preload(record, identities: [])

    {:ok, _view, html} =
      conn
      |> live("/worlds/people/#{record.id}")

    assert with_element(html, "#page_title") =~
             Pretty.get(record, :name)
  end
end
