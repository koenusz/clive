defmodule Clive.Repo do
  use Ecto.Repo,
    otp_app: :clive,
    adapter: Ecto.Adapters.Postgres
end
