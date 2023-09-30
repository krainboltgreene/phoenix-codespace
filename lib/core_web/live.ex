defmodule CoreWeb.Live do
  @moduledoc """
  A collection of live helpers
  """
  def on_mount(:tenancy, _params, %{"world_id" => world_id}, socket) when is_binary(world_id) do
    Core.Universes.get_world(world_id)
    |> case do
      nil ->
        Utilities.put_world_id(nil)

        socket
        |> Phoenix.Component.assign(:world_id, nil)
        |> Phoenix.Component.assign(:world, nil)

      world ->
        Utilities.put_world_id(world_id)

        socket
        |> Phoenix.Component.assign(:world_id, world_id)
        |> Phoenix.Component.assign(:world, world)
    end
    |> (&{:cont, &1}).()
  end

  def on_mount(:tenancy, _params, _session, socket) do
    socket
    |> Phoenix.Component.assign(:world_id, nil)
    |> Phoenix.Component.assign(:world, nil)
    |> (&{:cont, &1}).()
  end
end
