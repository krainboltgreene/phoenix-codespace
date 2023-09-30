defmodule CoreWeb.RoomDetailOptionLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.DataFixtures

  setup :register_and_log_in_account
  setup :make_account_an_administrator
  setup :with_room_detail_options

  test "listing", %{conn: conn, room_detail_options: records} do
    {:ok, _view, html} =
      conn
      |> live("/admin/room_detail_options")

    assert with_element(html, "#page_title") =~
             "Room Detail Options"

    titles = with_element(html, ".card-grid .card-title")

    for record <- records do
      assert titles =~
               Pretty.get(record, :name)
    end
  end

  test "details", %{conn: conn, room_detail_options: [record | _]} do
    {:ok, _view, html} =
      conn
      |> live("/admin/room_detail_options/#{record.id}")

    assert with_element(html, "#page_title") =~
             "Room Detail Option / #{Pretty.get(record, :name)}"
  end
end
