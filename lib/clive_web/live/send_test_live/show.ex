defmodule CliveWeb.SendTestLive.Show do
  use CliveWeb, :live_view

  alias Clive.Transaction

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:send_test, Transaction.get_send_test!(id))}
  end

  defp page_title(:show), do: "Show Send test"
  defp page_title(:edit), do: "Edit Send test"
end
