defmodule CoreWeb.<%= inspect schema.alias %>LiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures<%= unless context.module == Core.Data do %>
  import Core.DataFixtures<% end %>
  import <%= inspect context.module %>Fixtures

  setup :register_and_log_in_account
  <%= if context.module == Core.Data do %>setup :make_account_an_administrator<% else %>setup :with_worlds
  setup :set_world_as_tenant
  setup :set_current_world_in_session
  setup :with_name_options<% end %>
  setup :with_<%= schema.plural %>

  test "listing", %{conn: conn, <%= schema.plural %>: records} do
    {:ok, _view, html} =
      conn
      |> live("/<%= if context.module == Core.Data do "admin" else "worlds" end %>/<%= schema.plural %>")

    assert with_element(html, "#page_title") =~ "<%= schema.plural |> String.replace("_", " ") |> Utilities.String.titlecase() %><%= if context.module == Core.Data do %><% end %>"
    assert with_element(html, "button[phx-click='create']") =~ "Generate <%= schema.singular |> String.replace("_", " ") |> Utilities.String.titlecase() %>"

    for record <- Core.Repo.preload(records, []) do
      assert with_element(html, "##{record.id}") =~
               Pretty.get(record, :name)
    end
  end

  test "details", %{conn: conn, <%= schema.plural %>: [record | _]} do
    record = Core.Repo.preload(record, [])

    {:ok, _view, html} =
      conn
      |> live("/<%= if context.module == Core.Data do "admin" else "worlds" end %>/<%= schema.plural %>/#{record.id}")

    assert with_element(html, "#page_title") =~
             Pretty.get(record, :name)
  end
end
