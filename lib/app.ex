defmodule RegularTask.Application do
  use Application

  def start(_type, _args) do
    children = [
      %{
        id: TaskServer,
        start: {TaskServer, :start_link, []}
      },
      RegularTask.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: RegularTask.Supervisor)
  end
end
