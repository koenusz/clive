defmodule CliveWeb.SendTestLive.Index do
  use CliveWeb, :live_view

  alias Clive.Transaction
  alias Clive.Transaction.SendTest

  import CliveWeb.WalletComponents

  @impl true
  def mount(_params, _session, socket) do
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
end
