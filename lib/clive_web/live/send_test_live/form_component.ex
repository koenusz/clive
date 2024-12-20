defmodule CliveWeb.SendTestLive.FormComponent do
  use CliveWeb, :live_component

  alias Clive.Transaction

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage send_test records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="send_test-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:address]} type="text" label="Address" />
        <.input field={@form[:amount]} type="number" label="Amount" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Send test</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{send_test: send_test} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Transaction.change_send_test(send_test))
     end)}
  end

  @impl true
  def handle_event("validate", %{"send_test" => send_test_params}, socket) do
    changeset = Transaction.change_send_test(socket.assigns.send_test, send_test_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"send_test" => send_test_params}, socket) do
    save_send_test(socket, socket.assigns.action, send_test_params)
  end

  defp save_send_test(socket, :edit, send_test_params) do
    case Transaction.update_send_test(socket.assigns.send_test, send_test_params) do
      {:ok, send_test} ->
        notify_parent({:saved, send_test})

        {:noreply,
         socket
         |> put_flash(:info, "Send test updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_send_test(socket, :new, send_test_params) do
    case Transaction.create_send_test(send_test_params) do
      {:ok, send_test} ->
        notify_parent({:saved, send_test})

        {:noreply,
         socket
         |> put_flash(:info, "Send test created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
