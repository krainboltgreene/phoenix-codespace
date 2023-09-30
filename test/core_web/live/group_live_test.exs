defmodule CoreWeb.GroupLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.DataFixtures
  import Core.UniversesFixtures

  setup :register_and_log_in_account
  setup :with_worlds
  setup :set_world_as_tenant
  setup :set_current_world_in_session
  setup :with_name_options
  setup :with_groups

  test "listing", %{conn: conn, groups: records} do
    {:ok, _view, html} =
      conn
      |> live("/worlds/groups")

    assert with_element(html, "#page_title") =~ "Groups"
    assert with_element(html, "button[phx-click='create']") =~ "Generate Group"

    for record <- Core.Repo.preload(records, []) do
      assert with_element(html, "##{record.id}") =~
               Pretty.get(record, :name)
    end
  end

  test "details", %{conn: conn, groups: [record | _]} do
    record = Core.Repo.preload(record, [])

    {:ok, _view, html} =
      conn
      |> live("/worlds/groups/#{record.id}")

    assert with_element(html, "#page_title") =~
             Pretty.get(record, :name)
  end
end
