defmodule RegularTask.Repo.Migrations.CreateCrowdedness do
  use Ecto.Migration

  def change do
    create table(:crowd_stats) do
      add :applications_calling, :string
      add :applications_called, :string
      add :applications_waiting, :string

      add :permissions_calling, :string
      add :permissions_called, :string
      add :permissions_waiting, :string

      add :residence_cards_calling, :string
      add :residence_cards_called, :string
      add :residence_cards_waiting, :string

      add :consultations_cards_calling, :string
      add :consultations_called, :string
      add :consultations_waiting, :string

      add :permanent_residences_cards_calling, :string
      add :permanent_residences_called, :string
      add :permanent_residences_waiting, :string

      add :others_calling, :string
      add :others_called, :string
      add :others_waiting, :string

      timestamps()
    end
  end
end
