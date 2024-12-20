defmodule Clive.Transaction.SendTest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "send_tests" do
    field :address, :string
    field :amount, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(send_test, attrs) do
    send_test
    |> cast(attrs, [:address, :amount])
    |> validate_required([:address, :amount])
  end
end
