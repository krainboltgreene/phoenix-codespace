defmodule CoreWeb.PersonAppearanceOptionLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.DataFixtures

  setup :register_and_log_in_account
  setup :make_account_an_administrator
  setup :with_person_appearance_options

  test "listing", %{conn: conn, person_appearance_options: records} do
    {:ok, _view, html} =
      conn
      |> live("/admin/person_appearance_options")

    assert with_element(html, "#page_title") =~
             "Person Appearance Options"

    titles = with_element(html, ".card-grid .card-title")

    for record <- records do
      assert titles =~
               Pretty.get(record, :name)
    end
  end

  test "details", %{conn: conn, person_appearance_options: [record | _]} do
    {:ok, _view, html} =
      conn
      |> live("/admin/person_appearance_options/#{record.id}")

    assert with_element(html, "#page_title") =~
             "Person Appearance Option / #{Pretty.get(record, :name)}"
  end
end
