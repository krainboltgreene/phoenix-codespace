defmodule CoreWeb.AdventureLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.DataFixtures
  import Core.UniversesFixtures
  import Core.StoriesFixtures

  setup :register_and_log_in_account
  setup :with_worlds
  setup :set_world_as_tenant
  setup :set_current_world_in_session
  setup :with_name_options
  setup :with_adventures

  test "listing", %{conn: conn, adventures: records} do
    {:ok, _view, html} =
      conn
      |> live("/worlds/adventures")

    assert with_element(html, "#page_title") =~ "Adventures"

    assert with_element(html, "button[phx-click='create']") =~ "Generate Adventure"
    titles = with_element(html, ".card-grid .card-title")

    for record <- records do
      assert titles =~
               Pretty.get(record, :name)
    end
  end

  test "details", %{conn: conn, adventures: [record | _]} do
    {:ok, _view, html} =
      conn
      |> live("/worlds/adventures/#{record.id}")

    assert with_element(html, "#page_title") =~
             "Adventure / #{Pretty.get(record, :name)}"
  end
end
