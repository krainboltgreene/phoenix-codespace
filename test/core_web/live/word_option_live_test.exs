defmodule CoreWeb.WordOptionLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.DataFixtures

  setup :register_and_log_in_account
  setup :make_account_an_administrator
  setup :with_word_options

  test "listing", %{conn: conn, word_options: records} do
    {:ok, _view, html} =
      conn
      |> live("/admin/word_options")

    assert with_element(html, "#page_title") =~ "Word Options"
    titles = with_element(html, ".card-grid .card-title")

    for record <- records do
      assert titles =~ Pretty.get(record, :id)
    end
  end

  test "details", %{conn: conn, word_options: [record | _]} do
    {:ok, _view, html} =
      conn
      |> live("/admin/word_options/#{Pretty.get(record, :id)}")

    assert with_element(html, "#page_title") =~ Pretty.get(record, :id)
  end
end
