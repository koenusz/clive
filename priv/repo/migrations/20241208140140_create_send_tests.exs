defmodule Clive.Repo.Migrations.CreateSendTests do
  use Ecto.Migration

  def change do
    create table(:send_tests) do
      add :address, :string
      add :amount, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
