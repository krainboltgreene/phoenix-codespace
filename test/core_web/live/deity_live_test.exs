defmodule CoreWeb.DeityLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.DataFixtures
  import Core.UniversesFixtures

  setup :register_and_log_in_account
  setup :with_worlds
  setup :set_world_as_tenant
  setup :set_current_world_in_session
  setup :with_name_options
  setup :with_deities

  test "details", %{conn: conn, deities: [record | _]} do
    record = Core.Repo.preload(record, person: [identities: []])

    {:ok, _view, html} =
      conn
      |> live("/worlds/deities/#{record.id}")

    assert with_element(html, "#page_title") =~
             Pretty.get(record, :name)
  end
end
