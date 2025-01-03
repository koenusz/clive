defmodule CliveWeb.SendTestLive.Index do
  use CliveWeb, :live_view

  alias Clive.Transaction
  alias Clive.Transaction.SendTest

  import CliveWeb.WalletComponents

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:hello, "hello from elixir")
      |> assign(:wallets, [])
      |> assign(:connected, nil)
      |> assign(:selected, nil)
      |> assign(:balance, 0)

    {:ok, stream(socket, :send_tests, Transaction.list_send_tests())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Send test")
    |> assign(:send_test, Transaction.get_send_test!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Send test")
    |> assign(:send_test, %SendTest{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Send tests")
    |> assign(:send_test, nil)
  end

  @impl true
  def handle_info({CliveWeb.SendTestLive.FormComponent, {:saved, send_test}}, socket) do
    {:noreply, stream_insert(socket, :send_tests, send_test)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    send_test = Transaction.get_send_test!(id)
    {:ok, _} = Transaction.delete_send_test(send_test)

    {:noreply, stream_delete(socket, :send_tests, send_test)}
  end

  @impl true
  def handle_event("hello", msg, socket) do
    socket = assign(socket, hello: msg)
    {:noreply, socket}
  end

  @impl true
  def handle_event("wallets", wallets, socket) do
    mapped =
      Enum.map(wallets, fn %{"name" => name, "icon" => icon} -> %{name: name, icon: icon} end)

    socket = assign(socket, wallets: mapped)
    {:noreply, socket}
  end

  @impl true
  def handle_event("balance", amount, socket) do
    socket = assign(socket, balance: amount)
    {:noreply, socket}
  end

  @impl true
  def handle_event("connected", %{"wallet" => wallet, "balance" => balance}, socket) do
    connectedWallet =
      socket.assigns.wallets
      |> Enum.find(fn %{name: name} -> name == wallet end)

    socket =
      socket
      |> assign(connected: connectedWallet)
      |> assign(wallets: [])
      |> assign(balance: balance)

    {:noreply, socket}
  end

  def handle_event("select", %{"address" => address, "amount" => amount}, socket) do
    selected = %{address: address, amount: amount}

    socket =
      socket
      |> assign(selected: selected)

    {:noreply, socket}
  end
end
