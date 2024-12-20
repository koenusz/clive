defmodule Clive.TransactionFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Clive.Transaction` context.
  """

  @doc """
  Generate a send_test.
  """
  def send_test_fixture(attrs \\ %{}) do
    {:ok, send_test} =
      attrs
      |> Enum.into(%{
        address: "some address",
        amount: 42
      })
      |> Clive.Transaction.create_send_test()

    send_test
  end
end
