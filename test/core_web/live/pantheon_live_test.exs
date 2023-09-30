defmodule CoreWeb.PantheonLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.DataFixtures
  import Core.UniversesFixtures

  setup :register_and_log_in_account
  setup :with_worlds
  setup :set_world_as_tenant
  setup :set_current_world_in_session
  setup :with_name_options
  setup :with_pantheons

  test "listing", %{conn: conn, pantheons: records} do
    {:ok, _view, html} =
      conn
      |> live("/worlds/pantheons")

    assert with_element(html, "#page_title") =~ "Pantheons"
    assert with_element(html, "button[phx-click='create']") =~ "Generate Pantheon"

    for record <- Core.Repo.preload(records, []) do
      assert with_element(html, "##{record.id}") =~
               Pretty.get(record, :name)
    end
  end

  test "details", %{conn: conn, pantheons: [record | _]} do
    record = Core.Repo.preload(record, [])

    {:ok, _view, html} =
      conn
      |> live("/worlds/pantheons/#{record.id}")

    assert with_element(html, "#page_title") =~
             Pretty.get(record, :name)
  end
end
