defmodule RegularTask.MixProject do
  use Mix.Project

  def project do
    [
      app: :regular_task,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      env: [leeroy: "oyoy", tzone: "Japan"],
      mod: {RegularTask.Application, []},
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tzdata, "~> 1.1"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
