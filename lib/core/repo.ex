defmodule Core.Repo do
  @moduledoc """
  A set of funcionality that relates to the specific database we use (postgresql).
  """
  use Ecto.Repo,
    otp_app: :core,
    adapter: Ecto.Adapters.Postgres

  require Ecto.Query

  @impl true
  def default_options(_operation) do
    [world_id: Utilities.get_world_id()]
  end

  @impl true
  def prepare_query(_operation, %{from: %{source: {_, nil}}} = query, options),
    do: {query, options}

  def prepare_query(_operation, %{from: %{source: {_, Core.Universes.World}}} = query, options),
    do: {query, options}

  def prepare_query(_operation, %{from: %{source: {_, module}}} = query, options) do
    cond do
      options[:global] || options[:schema_migration] ->
        {query, options}

      options[:world_id] &&
          (module.__schema__(:association, :world) || module == Core.Content.Generation) ->
        {Ecto.Query.where(query, world_id: ^options[:world_id]), options}

      module == Core.Content.Generation ->
        {query, options}

      module.__schema__(:association, :world) ->
        raise "expected to be given a world_id value or Utilities.get_world_id() to return an id for #{module}"

      true ->
        {query, options}
    end
  end
end
