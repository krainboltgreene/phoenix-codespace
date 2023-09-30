defmodule CoreWeb.<%= inspect schema.alias %>Live do
  @moduledoc false
  use CoreWeb, :live_view
  use CoreWeb.Channels.Worlds, {:live_hook, :<%= schema.plural %>}
  <%= unless context.module == Core.Data do %>
  on_mount({CoreWeb.Channels.Worlds, :listen})<% end %>

  defp list_path(), do: ~p"/worlds/<%= schema.plural %>"

  def list_records(_assigns, _params) do
    Core.Universes.list_<%= schema.plural %>(fn schema ->
      from(
        schema,
        order_by: [desc: :updated_at],
        preload: []
      )
    end)
  end

  defp get_record(id) when is_binary(id) do
    Core.Universes.get_<%= schema.singular %>(id)
    |> case do
      nil ->
        {:error, :not_found}

      record ->
        Core.Repo.preload(record, [])
    end
  end

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign(:page_title, "Loading...")
    |> (&{:ok, &1}).()
  end

  @impl true
  def handle_params(params, _url, %{assigns: %{live_action: :list}} = socket) do
    records = list_records(socket.assigns, params)

    socket
    |> assign(:page_title, "<%= schema.plural |> String.replace("_", " ") |> Utilities.String.titlecase() %> #{length(records)}")
    |> assign(:records, records)
    |> (&{:noreply, &1}).()
  end

  def handle_params(%{"id" => id}, _url, %{assigns: %{live_action: :show}} = socket)
      when is_binary(id) do
    get_record(id)
    |> case do
      {:error, :not_found} ->
        raise CoreWeb.Exceptions.NotFoundException

      record ->
        socket
        |> assign(:page_title, Pretty.get(record, :name))
        |> assign(:record, record)
    end
    |> (&{:noreply, &1}).()
  end

  @impl true
  def handle_event("create", _, socket) do
    {:ok, :generating} = Core.Universes.lazy_generate_<%= schema.singular %>()

    socket
    |> assign(:create_loading, true)
    |> assign(:records, list_records(socket.assigns, %{}))
    |> (&{:noreply, &1}).()
  end

  @impl true
  def render(%{live_action: :list} = assigns) do
    ~H"""
    <.card_grid>
      <:empty>
        <.card>
          <div class="rounded border-2 border-dashed border-gray-300 p-8 my-4 text-center">
            <.icon as="user" modifiers="text-9xl text-contrast-500" />
          </div>
          <:footer>
            <.button phx-click="create" state={if(assigns[:create_loading], do: "busy")} usable_icon="dice" class={["my-4"]}>
              Generate <%= inspect schema.alias %>
            </.button>
          </:footer>
        </.card>
      </:empty>
      <:cards :for={record <- @records}>
        <.card id={record.id}>
          <h5 class="font-bold text-xl mb-2">
            <.link patch={~p"/worlds/<%= schema.plural %>/#{record.id}"}>
              <.generated record={record} property="name" display="text">
                <%%= Pretty.get(record, :name) %>
              </.generated>
            </.link>
          </h5>
          <p>
          </p>

          <:footer>
            <p class="text-sm">
              Last updated <.timestamp_in_words_ago at={record.updated_at} />
            </p>
          </:footer>
        </.card>
      </:cards>
    </.card_grid>
    """
  end

  @impl true
  def render(%{live_action: :show} = assigns) do
    ~H"""
    """
  end
end
