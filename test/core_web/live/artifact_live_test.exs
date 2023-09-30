defmodule CoreWeb.ArtifactLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.DataFixtures
  import Core.UniversesFixtures

  setup :register_and_log_in_account
  setup :with_worlds
  setup :set_world_as_tenant
  setup :set_current_world_in_session
  setup :with_name_options
  setup :with_artifacts

  test "listing", %{conn: conn, artifacts: records} do
    {:ok, _view, html} =
      conn
      |> live("/worlds/artifacts")

    assert with_element(html, "#page_title") =~ "Artifacts"
    assert with_element(html, "button[phx-click='create']") =~ "Generate Artifact"

    for record <- Core.Repo.preload(records, []) do
      assert with_element(html, "##{record.id}") =~
               Pretty.get(record, :name)
    end
  end

  test "details", %{conn: conn, artifacts: [record | _]} do
    record = Core.Repo.preload(record, [])

    {:ok, _view, html} =
      conn
      |> live("/worlds/artifacts/#{record.id}")

    assert with_element(html, "#page_title") =~
             Pretty.get(record, :name)
  end
end
