defmodule CoreWeb.CultureLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.DataFixtures
  import Core.UniversesFixtures

  setup :register_and_log_in_account
  setup :with_worlds
  setup :set_world_as_tenant
  setup :set_current_world_in_session
  setup :with_name_options
  setup :with_cultures

  test "listing", %{conn: conn, cultures: records} do
    {:ok, _view, html} =
      conn
      |> live("/worlds/cultures")

    assert with_element(html, "#page_title") =~ "Cultures"
    assert with_element(html, "button[phx-click='create']") =~ "Generate Culture"

    for record <- Core.Repo.preload(records, []) do
      assert with_element(html, "##{record.id}") =~
               Pretty.get(record, :name)
    end
  end

  test "details", %{conn: conn, cultures: [record | _]} do
    record = Core.Repo.preload(record, [])

    {:ok, _view, html} =
      conn
      |> live("/worlds/cultures/#{record.id}")

    assert with_element(html, "#page_title") =~
             Pretty.get(record, :name)
  end
end
