defmodule CoreWeb.ContentComponents do
  @moduledoc """
  Provides content UI components.
  """
  use Phoenix.Component
  use CoreWeb, :verified_routes

  # alias Phoenix.LiveView.JS
  # import CoreWeb.Gettext

  attr :rest, :global
  slot :inner_block, required: true, doc: "The title of the page"

  def page_title(assigns) do
    ~H"""
    <header class="bg-dark-500">
      <div class="mx-auto max-w-7xl py-2">
        <h1 id="page_title" class="text-3xl font-bold leading-tight tracking-tight text-light-500" {@rest}><%= render_slot(@inner_block) %></h1>
      </div>
    </header>
    """
  end

  attr :rest, :global
  attr :id, :string, required: true

  slot :tab, doc: "A list of tabs" do
    attr :patch, :string
  end

  slot :subtitle, doc: "A cute subtitle"
  slot :inner_block, required: true, doc: "The title of the section"

  def section_title(assigns) do
    ~H"""
    <div class="not-prose border-b border-gray-200 mt-8 mb-4">
      <div class="ml-2 mt-2 flex flex-wrap items-baseline">
        <h3 class="ml-2 mt-2 text-base font-semibold leading-6 text-gray-900" id={@id} {@rest}>
          <%= render_slot(@inner_block) %>
        </h3>
        <div :if={assigns[:tab]} class="mt-4">
          <nav class="-mb-px flex space-x-8">
            <!-- Current: "border-indigo-500 text-indigo-600", Default: "border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700" -->
            <.link :for={tab <- @tab} patch={tab.patch} class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 whitespace-nowrap border-b-2 px-1 pb-2 text-sm font-medium">
              <%= render_slot(tab) %>
            </.link>
          </nav>
        </div>
        <p :if={@subtitle} class="ml-2 mt-1 truncate text-sm text-gray-500"><%= render_slot(@subtitle) %></p>
      </div>
    </div>
    """
  end

  attr :rest, :global
  slot :empty, doc: "An empty placeholder for the other cards"
  slot :cards, doc: "A list of cards"
  slot :inner_block, doc: "The main content of the card"

  def card_grid(assigns) do
    ~H"""
    <ul role="list" class="grid grid-cols-1 gap-6 grid-cols-3" {@rest}>
      <%= @empty && render_slot(@empty) %>
      <%= render_slot(@inner_block) %>
      <%= render_slot(@cards) %>
    </ul>
    """
  end

  attr :rest, :global
  attr :image_url, :string, default: nil
  attr :image_alt, :string, default: nil
  slot :title, doc: "The title of the card"
  slot :image, doc: "An image at the top of the card"
  slot :inner_block, required: true, doc: "The main content of the card"
  slot :footer, doc: "The footer content of the card"

  def card(assigns) do
    ~H"""
    <li class="max-w-sm rounded overflow-shadow-lg border-dark-500 bg-white flex flex-col items-center border-2 border-contrast-500" {@rest}>
      <div class="px-6 py-4 basis-3/4 flex flex-col justify-center">
        <%= render_slot(@image) %>
        <img :if={@image_url} class="mx-auto h-32 w-32 flex-shrink-0" src={@image_url} alt={@image_alt} />
        <%= render_slot(@title) %>
        <%= render_slot(@inner_block) %>
      </div>
      <div :if={@footer} class="px-6 pt-4 pb-2 basis-1/4 flex flex-col justify-center">
        <%= render_slot(@footer) %>
      </div>
    </li>
    """
  end

  @doc """
  Renders the site header
  """
  attr :current_account, Core.Users.Account, default: nil
  attr :namespace, :string, required: true
  attr :world, Core.Universes.World, default: nil

  def site_header(assigns) do
    ~H"""
    <nav class="">
      <div class="mx-auto px-4 border-b-2 border-dark-500 bg-white">
        <div class="flex h-16 justify-between">
          <div class="flex">
            <div class="flex flex-shrink-0 items-center">
              <h1 class="text-3xl font-bold leading-tight tracking-tight text-gray-900">Phoenix Project</h1>
            </div>
          </div>

          <div class="flex">
            <.site_header_link :if={@current_account} navigate={~p"/accounts/settings"}>Account</.site_header_link>
            <.site_header_link :if={@current_account} href={~p"/accounts/log_out"} method="delete">Log out</.site_header_link>
            <.site_header_link :if={!@current_account} navigate={~p"/accounts/register"}>Register</.site_header_link>
            <.site_header_link :if={!@current_account} navigate={~p"/accounts/log_in"}>Log in</.site_header_link>
          </div>
        </div>
      </div>
      <div class="mx-auto px-4">
        <div class="flex flex-wrap h-16">
          <.site_header_link :if={@current_account} navigate={~p"/worlds"}>Worlds</.site_header_link>
          <.site_header_link :if={Core.Users.has_permission?(@current_account, "global", "administrator")} navigate={~p"/admin"}>
            <%= if @namespace == "admin" do %>
              Dashboard
            <% else %>
              Admin
            <% end %>
          </.site_header_link>
          <.site_header_link :for={{path, name} <- admin_links()} :if={@current_account && @namespace == "admin"} navigate={path}>
            <%= name %>
          </.site_header_link>
          <.site_header_link :for={{path, name} <- admin_data_links()} :if={@current_account && @namespace == "admin"} navigate={path}>
            <%= name %>
          </.site_header_link>
          <.site_header_link :if={@current_account && @namespace == "admin"} navigate={~p"/admin/phoenix"}>
            Phoenix
          </.site_header_link>
          <.site_header_link :for={{path, name} <- world_links()} :if={@world && @current_account && @namespace != "admin"} navigate={path}>
            <%= name %>
          </.site_header_link>
        </div>
      </div>
    </nav>
    """
  end

  attr :current?, :boolean, default: false

  attr :rest, :global,
    include: ~w(navigate href method),
    doc: "the arbitrary HTML attributes to add to the link"

  slot :inner_block, required: true

  def site_header_link(assigns) do
    ~H"""
    <.link :if={@current?} class="border-indigo-500 text-contrast-500 inline-flex items-center px-1 pt-1 text-sm font-medium decoration-solid" aria-current="page" {@rest}>
      <%= render_slot(@inner_block) %>
    </.link>
    <.link :if={!@current?} class="text-contrast-500 hover:border-gray-300 hover:text-highlight-500 inline-flex items-center px-1 pt-1 text-sm font-medium decoration-solid" {@rest}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  @doc """
  Renders the site footer.
  """
  attr :world, Core.Universes.World, default: nil
  attr :current_account, Core.Users.Account, default: nil

  def site_footer(assigns) do
    ~H"""
    <footer class="bg-dark-500 text-contrast-500">
      <div :if={@world} id="current_world_indicator" class="mx-auto w-full max-w-screen-xl">
        Currently viewing world <.link patch={~p"/worlds/#{@world.id}"}><%= Pretty.get(@world, :name) %></.link>, go <.link navigate={~p"/worlds"}>here</.link> to see other worlds.
      </div>
      <div class="mx-auto w-full max-w-screen-xl">
        <div class="grid grid-cols-2 gap-8 px-3 py-2">
          <div>
            <h2 class="mb-6 text-sm font-semibold text-highlight-500 uppercase">
              <%= Application.get_env(:core, :application_name) %>
            </h2>
            <ul>
              <li class="mb-4">
                <.link navigate={~p"/"} class="text-light-500 font-medium hover:underline">Home</.link>
              </li>
              <li class="mb-4">
                <.link navigate={~p"/pricing"} class="text-light-500 font-medium hover:underline">Pricing</.link>
              </li>
              <li class="mb-4">
                <.link navigate={~p"/faq"} class="text-light-500 font-medium hover:underline">FAQ</.link>
              </li>
              <li class="mb-4">
                <.link navigate={~p"/about_us"} class="text-light-500 font-medium hover:underline">About Us</.link>
              </li>
            </ul>
          </div>
          <div>
            <h2 class="mb-6 text-sm font-semibold text-highlight-500 uppercase">
              Authentication
            </h2>
            <ul>
              <li :if={@current_account} class="mb-4">
                <strong class="text-light-500 font-medium"><%= @current_account.username %></strong>
              </li>
              <li :if={@current_account} class="mb-4">
                <.link navigate={~p"/accounts/settings"} class="text-light-500 font-medium hover:underline">Account</.link>
              </li>
              <li :if={@current_account} class="mb-4">
                <.link href={~p"/accounts/log_out"} method="delete" class="text-light-500 font-medium hover:underline">
                  Log out
                </.link>
              </li>
              <li :if={!@current_account} class="mb-4">
                <.link navigate={~p"/accounts/register"} class="text-light-500 font-medium hover:underline">Register</.link>
              </li>
              <li :if={!@current_account} class="mb-4">
                <.link navigate={~p"/accounts/log_in"} class="text-light-500 font-medium hover:underline">Log in</.link>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </footer>
    """
  end

  # def table(assigns) do
  #   ~H"""
  #   """
  # end

  defp world_links,
    do: [
      {~p"/worlds/cultures", "Cultures"},
      {~p"/worlds/religions", "Religions"},
      {~p"/worlds/pantheons", "Pantheons"},
      {~p"/worlds/locations", "Locations"},
      {~p"/worlds/groups", "Groups"},
      {~p"/worlds/people", "People"},
      {~p"/worlds/artifacts", "Artifacts"},
      {~p"/worlds/adventures", "Adventures"},
      {~p"/worlds/encounters", "Encounters"}
    ]

  defp admin_links(),
    do: [
      {~p"/admin/accounts", "Accounts"},
      {~p"/admin/organizations", "Organizations"},
      {~p"/admin/jobs", "Jobs"},
      {~p"/admin/gpu_servers", "GPUs"},
      {~p"/admin/image_batches", "Image Batches"}
    ]

  defp admin_data_links(),
    do: [
      {~p"/admin/archetype_options", "Archetype Options"},
      {~p"/admin/asset_options", "Asset Options"},
      {~p"/admin/background_options", "Background Options"},
      {~p"/admin/cultural_art_options", "Cultural Art Options"},
      {~p"/admin/cultural_ethos_options", "Cultural Ethos Options"},
      {~p"/admin/cultural_gender_preference_options", "Cultural Gender Preference Options"},
      {~p"/admin/cultural_phase_options", "Cultural Phase Options"},
      {~p"/admin/cultural_pillar_options", "Cultural Pillar Options"},
      {~p"/admin/cultural_scale_options", "Cultural Scale Options"},
      {~p"/admin/cultural_society_options", "Cultural Society Options"},
      {~p"/admin/encounter_context_options", "Encounter Context Options"},
      {~p"/admin/gender_identity_options", "Gender Identity Options"},
      {~p"/admin/gender_presentation_options", "Gender Presentation Options"},
      {~p"/admin/group_age_options", "Group Age Options"},
      {~p"/admin/group_goal_options", "Group Goal Options"},
      {~p"/admin/group_scope_options", "Group Scope Options"},
      {~p"/admin/group_size_options", "Group Size Options"},
      {~p"/admin/location_development_options", "Location Development Options"},
      {~p"/admin/location_embellishment_options", "Location Embellishment Options"},
      {~p"/admin/location_founding_options", "Location Founding Options"},
      {~p"/admin/monsters", "Monsters"},
      {~p"/admin/objective_options", "Objective Options"},
      {~p"/admin/person_appearance_options", "Person Appearance Options"},
      {~p"/admin/person_role_options", "Person Role Options"},
      {~p"/admin/person_type_options", "Person Type Options"},
      {~p"/admin/race_options", "Race Options"},
      {~p"/admin/religion_value_options", "Religion Value Options"},
      {~p"/admin/room_detail_options", "Room Detail Options"},
      {~p"/admin/trait_options", "Trait Options"},
      {~p"/admin/trap_bait_options", "Trap Bait Options"},
      {~p"/admin/trap_effect_options", "Trap Effect Options"},
      {~p"/admin/trap_lethality_options", "Trap Lethality Options"},
      {~p"/admin/trap_location_options", "Trap Location Options"},
      {~p"/admin/trap_purpose_options", "Trap Purpose Options"},
      {~p"/admin/trap_reset_options", "Trap Reset Options"},
      {~p"/admin/trap_trigger_options", "Trap Trigger Options"},
      {~p"/admin/trap_type_options", "Trap Type Options"}
    ]
end
