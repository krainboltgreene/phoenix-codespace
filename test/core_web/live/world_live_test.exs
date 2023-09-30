defmodule CoreWeb.WorldLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.DataFixtures
  import Core.UniversesFixtures

  setup :register_and_log_in_account
  setup :with_name_options
  setup :with_worlds
  setup :reverse_associate_worlds
  setup :stub_account_session_fetch

  test "listing", %{conn: conn, worlds: records} do
    {:ok, _view, html} =
      conn
      |> live("/worlds")

    assert with_element(html, "#page_title") =~ "Worlds"

    assert with_element(html, "button[phx-click='create']") =~ "Generate World"

    for record <- records do
      assert with_element(html, "##{record.id}") =~
               Pretty.get(record, :name)
    end
  end

  test "details", %{conn: conn, worlds: [record | _]} do
    {:ok, _view, html} =
      conn
      |> live("/worlds/#{record.id}")

    assert with_element(html, "#page_title") =~
             Pretty.get(record, :name)
  end

  test "tenancy when the tenant is destroyed", %{conn: conn, worlds: [world | _]} do
    {:ok, view, _html} =
      conn
      |> live("/worlds/#{world.id}")

    view
    |> element("button[phx-click='open']")
    |> render_click()

    {:ok, _view, html} =
      conn
      |> live("/worlds")

    assert html =~ "Generate World"
  end
end
