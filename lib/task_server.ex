defmodule TaskServer do
    @moduledoc """
    Simple genserver to perform a fixed task periodically.
    """
    use GenServer
    @interval_ms 15000

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

    defp say_date do
        dt = DateTime.now!(Application.fetch_env!(:regular_task, :tzone)) |> DateTime.truncate(:second)
        IO.puts("doing thing at #{DateTime.to_string(dt)}")
    end

    @impl true
    def handle_continue([], _state) do
        say_date()
        Process.sleep(@interval_ms)
        {:noreply, [], {:continue, []}}
    end

    @impl true
    def handle_cast({:do_periodic_thing}, _state) do
        say_date()
        Process.sleep(1000)
        {:noreply, [], {:continue, []}}
    end
end
