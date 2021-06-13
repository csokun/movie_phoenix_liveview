defmodule Movie.Repo do
  use Ecto.Repo,
    otp_app: :movie,
    adapter: Ecto.Adapters.Postgres
end
