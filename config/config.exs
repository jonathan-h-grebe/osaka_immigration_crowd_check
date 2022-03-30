import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
config :regular_task, ecto_repos: [RegularTask.Repo]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
