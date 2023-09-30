defmodule CoreWeb.GPUServerLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.ContentFixtures

  setup :register_and_log_in_account
  setup :make_account_an_administrator
  setup :with_gpu_servers

  test "listing", %{conn: conn, gpu_servers: records} do
    {:ok, _view, html} =
      conn
      |> live("/admin/gpu_servers")

    assert with_element(html, "#page_title") =~ "GPU Servers"

    for record <- records do
      assert with_element(
               html,
               ".card-title a[href='/admin/gpu_servers/#{record.id}']"
             ) =~ Pretty.get(record, :name)
    end
  end

  test "details", %{conn: conn, gpu_servers: [record | _]} do
    {:ok, _view, html} =
      conn
      |> live("/admin/gpu_servers/#{record.id}")

    assert with_element(html, "#page_title") =~
             Pretty.get(record, :name)
  end
end
