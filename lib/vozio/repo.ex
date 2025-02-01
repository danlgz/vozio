defmodule Vozio.Repo do
  use Ecto.Repo,
    otp_app: :vozio,
    adapter: Ecto.Adapters.Postgres
end
