defmodule CoreWeb.ActLiveTest do
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
  setup :with_acts

  test "details", %{conn: conn, acts: [record | _]} do
    {:ok, _view, html} =
      conn
      |> live("/worlds/acts/#{record.id}")

    assert with_element(html, "#page_title") =~
             "Act / #{Pretty.get(record, :name)}"
  end
end
