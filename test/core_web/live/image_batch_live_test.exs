defmodule CoreWeb.ImageBatchLiveTest do
  use CoreWeb.LiveCase, async: true
  import Core.SessionsFixtures
  import Core.ContentFixtures

  setup :register_and_log_in_account
  setup :make_account_an_administrator
  setup :with_image_batches

  test "listing", %{conn: conn, image_batches: image_batches} do
    {:ok, _view, html} =
      conn
      |> live("/admin/image_batches")

    assert with_element(html, "#page_title") =~
             "Image Batches"

    for image_batch <- image_batches do
      assert with_element(html, ".card-title a[href='/admin/image_batches/#{image_batch.id}']") =~
               Pretty.get(image_batch, :prompt)
    end
  end

  test "details", %{conn: conn, image_batches: [image_batch | _]} do
    {:ok, view, _html} =
      conn
      |> live("/admin/image_batches/#{image_batch.id}")

    assert has_element?(view, ".card img")
  end
end
