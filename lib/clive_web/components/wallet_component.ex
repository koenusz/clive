defmodule CliveWeb.WalletComponents do
  use Phoenix.Component

  @moduledoc false
  import SaladUI.DropdownMenu
  import SaladUI.Button
  import SaladUI.Menu
  import SaladUI.Icon

  # alias Phoenix.LiveView.JS

  @doc """
  Render dropdown menu
  """

  def wallet(assigns) do
    ~H"""
    <div id="wallet" class="mt-24">
      <.dropdown_menu>
        <.dropdown_menu_trigger>
          <.button variant="outline">Select Wallet</.button>
        </.dropdown_menu_trigger>
        <.dropdown_menu_content>
          <.menu class="w-56">
            <.menu_label>Account</.menu_label>
            <.menu_separator />
            <.menu_group>
              <.menu_item>
                <.icon name="hero-user" class="mr-2 h-4 w-4" />
                <span>Profile</span>
                <.menu_shortcut>⌘P</.menu_shortcut>
              </.menu_item>
              <.menu_item>
                <.icon name="hero-banknotes" class="mr-2 h-4 w-4" />
                <span>Billing</span>
                <.menu_shortcut>⌘B</.menu_shortcut>
              </.menu_item>
              <.menu_item>
                <.icon name="hero-cog-6-tooth" class="mr-2 h-4 w-4" />
                <span>Settings</span>
                <.menu_shortcut>⌘S</.menu_shortcut>
              </.menu_item>
            </.menu_group>
            <.menu_separator />
            <.menu_group>
              <.menu_item>
                <.icon name="hero-users" class="mr-2 h-4 w-4" />
                <span>Team</span>
              </.menu_item>
              <.menu_item disabled>
                <.icon name="hero-plus" class="mr-2 h-4 w-4" />
                <span>New team</span>
                <.menu_shortcut>⌘T</.menu_shortcut>
              </.menu_item>
            </.menu_group>
          </.menu>
        </.dropdown_menu_content>
      </.dropdown_menu>
    </div>
    """
  end
end
