defmodule CoreWeb.AssetOptionLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.DataFixtures

  setup :register_and_log_in_account
  setup :make_account_an_administrator
  setup :with_asset_options

  test "listing", %{conn: conn, asset_options: records} do
    {:ok, _view, html} =
      conn
      |> live("/admin/asset_options")

    assert with_element(html, "#page_title") =~ "Asset Options"
    titles = with_element(html, ".card-grid .card-title")

    for record <- records do
      assert titles =~
               Pretty.get(record, :name)
    end
  end

  test "details", %{conn: conn, asset_options: [record | _]} do
    {:ok, _view, html} =
      conn
      |> live("/admin/asset_options/#{record.id}")

    assert with_element(html, "#page_title") =~
             "Asset Option / #{Pretty.get(record, :name)}"
  end
end
