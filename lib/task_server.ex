defmodule TaskServer do
  @moduledoc """
  Simple genserver which performs fixed task periodically,
  during office hours (mon-friday 9AM- 430PM).
  """
  use GenServer

  @interval_s 300
  @interval_ms @interval_s * 100

  @office_hours_start ~T[09:00:00.000]
  @office_hours_end ~T[16:30:00.000]

  # client
  @spec start_link :: :ignore | {:error, any} | {:ok, pid}
  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  # Server (callbacks)
  @impl true
  def init(_) do
    {:ok, [], {:continue, []}}
  end

  @impl true
  def handle_continue([], _state) do
    now =
      DateTime.now!(Application.fetch_env!(:regular_task, :tzone))
      |> DateTime.truncate(:second)

    if sendable_time?(now), do: do_task(now)

    after_one_interval = DateTime.add(now, @interval_s, :second)

    cond do
      sendable_time?(after_one_interval) ->
        Process.sleep(@interval_ms)

      true ->
        until_next_opening_s =
          next_opening_time(now)
          |> DateTime.diff(now)

        Process.sleep(until_next_opening_s * 1000)
    end

    Process.sleep(@interval_ms)
    {:noreply, [], {:continue, []}}
  end

  defp sendable_time?(date_time_jst) do
    is_weekday?(date_time_jst) and is_within_office_hours?(date_time_jst)
  end

  defp is_weekday?(date_time_jst) do
    {day_of_week, _, _} =
      Calendar.ISO.day_of_week(
        date_time_jst.year,
        date_time_jst.month,
        date_time_jst.day,
        :monday
      )

    if day_of_week >= 1 and day_of_week <= 5 do
      true
    else
      false
    end
  end

  defp is_within_office_hours?(date_time_jst) do
    t = DateTime.to_time(date_time_jst)
    :gt == Time.compare(t, @office_hours_start) and :lt == Time.compare(t, @office_hours_end)
  end

  defp do_task(date_time_jst) do
    IO.puts("doing task at #{DateTime.to_string(date_time_jst)}")
    DataDownloader.call()
  end

  defp next_opening_time(now_date_time) do
    cond do
      is_weekday?(now_date_time) and
          :lt == Time.compare(DateTime.to_time(now_date_time), @office_hours_start) ->
        DateTime.new!(
          Date.new!(now_date_time.year, now_date_time.month, now_date_time.day),
          Time.new!(9, 0, 0, 1),
          "Japan"
        )

      true ->
        {day_of_week, _, _} =
          Calendar.ISO.day_of_week(
            now_date_time.year,
            now_date_time.month,
            now_date_time.day,
            :monday
          )

        days_until_next_weekday =
          case day_of_week do
            5 -> 3
            6 -> 2
            7 -> 1
            _ -> 1
          end

        DateTime.new!(
          Date.new!(now_date_time.year, now_date_time.month, now_date_time.day),
          Time.new!(9, 0, 0, 1),
          "Japan"
        )
        |> DateTime.add(60 * 60 * 24 * days_until_next_weekday, :second)
    end
  end
end
