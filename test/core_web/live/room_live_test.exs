defmodule CoreWeb.RoomLiveTest do
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
  setup :with_rooms

  test "details", %{conn: conn, rooms: [record | _]} do
    {:ok, _view, html} =
      conn
      |> live("/worlds/rooms/#{record.id}")

    assert with_element(html, "#page_title") =~ Pretty.get(record, :specific)
  end
end
