defmodule RegularTask.Repo do
  use Ecto.Repo,
    otp_app: :regular_task,
    adapter: Ecto.Adapters.Postgres
end
