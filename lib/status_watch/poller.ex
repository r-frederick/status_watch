defmodule StatusWatch.Poller do
  use GenServer

  def start_link(opts \\ []) do
    adapter = Application.fetch_env!(:status_watch, :adapter)

    GenServer.start_link(__MODULE__, %{adapter: adapter}, opts)
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:poll, state) do
    %{"currentTracking" => tracking} = Timeularex.tracking

    case tracking do
      nil -> state.adapter.update_status(%StatusWatch.Status{status_text: "", status_emoji: ":squirrel:"})
      %{"activity" => activity} -> state.adapter.update_status(map_activity(activity))
    end

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :poll, 2000)
  end

  defp map_activity(activity) do
    status_map = Application.fetch_env! :status_watch, :status_map

    {emoji, text} = status_map[activity["id"]]

    %StatusWatch.Status{status_text: text, status_emoji: emoji}
  end
end
