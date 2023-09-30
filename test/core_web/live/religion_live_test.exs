defmodule CoreWeb.ReligionLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.DataFixtures
  import Core.UniversesFixtures

  setup :register_and_log_in_account
  setup :with_worlds
  setup :set_world_as_tenant
  setup :set_current_world_in_session
  setup :with_name_options
  setup :with_religions

  test "listing", %{conn: conn, religions: records} do
    {:ok, _view, html} =
      conn
      |> live("/worlds/religions")

    assert with_element(html, "#page_title") =~ "Religions"
    assert with_element(html, "button[phx-click='create']") =~ "Generate Religion"

    for record <- Core.Repo.preload(records, []) do
      assert with_element(html, "##{record.id}") =~
               Pretty.get(record, :name)
    end
  end

  test "details", %{conn: conn, religions: [record | _]} do
    record = Core.Repo.preload(record, [:identities])

    {:ok, _view, html} =
      conn
      |> live("/worlds/religions/#{record.id}")

    assert with_element(html, "#page_title") =~
             Pretty.get(record, :name)
  end
end
