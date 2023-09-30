defmodule CoreWeb.MonsterLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.DataFixtures

  setup :register_and_log_in_account
  setup :make_account_an_administrator
  setup :with_monsters

  test "listing", %{conn: conn, monsters: records} do
    {:ok, _view, html} =
      conn
      |> live("/admin/monsters")

    assert with_element(html, "#page_title") =~ "Monsters"
    titles = with_element(html, ".card-grid .card-title")

    for record <- records do
      assert titles =~
               Pretty.get(record, :name)
    end
  end

  test "details", %{conn: conn, monsters: [record | _]} do
    {:ok, _view, html} =
      conn
      |> live("/admin/monsters/#{record.id}")

    assert with_element(html, "#page_title") =~
             "Monster / #{Pretty.get(record, :name)}"
  end
end
