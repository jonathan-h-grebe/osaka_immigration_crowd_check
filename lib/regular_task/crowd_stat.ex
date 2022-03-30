defmodule RegularTask.CrowdStat do
  use Ecto.Schema

  schema "crowd_stats" do
    field(:applications_calling, :string)
    field(:applications_called, :string)
    field(:applications_waiting, :string)

    field(:permissions_calling, :string)
    field(:permissions_called, :string)
    field(:permissions_waiting, :string)

    field(:residence_cards_calling, :string)
    field(:residence_cards_called, :string)
    field(:residence_cards_waiting, :string)

    field(:consultations_cards_calling, :string)
    field(:consultations_called, :string)
    field(:consultations_waiting, :string)

    field(:permanent_residences_cards_calling, :string)
    field(:permanent_residences_called, :string)
    field(:permanent_residences_waiting, :string)

    field(:others_calling, :string)
    field(:others_called, :string)
    field(:others_waiting, :string)

    timestamps()
  end

  @spec from(
          Crowdedness.t(),
          Crowdedness.t(),
          Crowdedness.t(),
          Crowdedness.t(),
          Crowdedness.t(),
          Crowdedness.t()
        ) :: any()
  def from(app, permi, resi, cons, perma, other) do
    %__MODULE__{
      applications_calling: app.calling,
      applications_called: app.called,
      applications_waiting: app.waiting,
      permissions_calling: permi.calling,
      permissions_called: permi.called,
      permissions_waiting: permi.waiting,
      residence_cards_calling: resi.calling,
      residence_cards_called: resi.called,
      residence_cards_waiting: resi.waiting,
      consultations_cards_calling: cons.calling,
      consultations_called: cons.called,
      consultations_waiting: cons.waiting,
      permanent_residences_cards_calling: perma.calling,
      permanent_residences_called: perma.called,
      permanent_residences_waiting: perma.waiting,
      others_calling: other.calling,
      others_called: other.called,
      others_waiting: other.waiting
    }
  end
end
