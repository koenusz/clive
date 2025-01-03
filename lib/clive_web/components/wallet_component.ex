defmodule CliveWeb.WalletComponents do
  use Phoenix.Component

  @moduledoc false
  import SaladUI.DropdownMenu
  import SaladUI.Button
  import SaladUI.Menu

  # alias Phoenix.LiveView.JS

  @doc """
  Render dropdown menu
  """

  def wallet(assigns) do
    ~H"""
    <div id="wallet-component" class="mt-24">
      <.dropdown_menu>
        <.dropdown_menu_trigger>
          <.button id="wallet-button" variant="outline" phx-hook="Wallets">
            <div :if={!@wallet}>
              Select Wallet
            </div>
            <div :if={@wallet} class="flex border ">
              <img src={@wallet.icon} width="26" class="icon" />
              <span>
                {@wallet.name}
              </span>
            </div>
          </.button>
        </.dropdown_menu_trigger>
        <.dropdown_menu_content>
          <.menu class="w-56">
            <.menu_label>Account</.menu_label>
            <.menu_separator />
            <.menu_group>
              <.menu_item
                :for={wallet <- @wallets}
                id={"wallet-item-#{wallet.name}"}
                data-wallet={wallet.name}
                phx-hook="Connect"
              >
                <%!-- <.icon name="hero-user" class="mr-2 h-4 w-4" /> --%>
                <img src={wallet.icon} width="36" class="icon" />
                <span>{wallet.name}</span>
              </.menu_item>
            </.menu_group>
          </.menu>
        </.dropdown_menu_content>
      </.dropdown_menu>
    </div>
    """
  end

  def balance(assigns) do
    ~H"""
    <div id="balance">
      Balance: {@balance}
    </div>
    """
  end
end
