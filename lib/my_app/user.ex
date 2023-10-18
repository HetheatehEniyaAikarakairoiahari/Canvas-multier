defmodule MyApp.User do
  use GenServer

  def start_link(_arg) do
    IO.puts("Starting Event Store Subscription")
    GenServer.start_link(__MODULE__, :ok, name: :wow)
  end

  # Initialization. Called when the module starts.
  def init(:ok) do
    subscribe()
    {:ok, []}
  end

  # Receive message: 'new event' from the event_store
  def handle_info({:new_event, start, end_point}, state) do
    {:noreply, state ++ [{start, end_point}]}
  end

  def handle_info({:get_state, from}, state) do
    send(from, {:get_state, state})
    {:noreply, state}
  end

  def subscribe do
    Phoenix.PubSub.subscribe(MyApp.PubSub, "some_topic")
  end

  # Unhandled messages
  def handle_info(msg, state) do
    IO.puts("Received an unhandled message: #{inspect(msg)}")
    IO.puts("This is the state: #{inspect(state)}")
    {:noreply, state}
  end


  def add_line(start, finish) do
    GenServer.cast(:handle, {:add_line, start, finish})
  end

  def get_lines() do
    GenServer.call(:handle, :get_lines)
  end

  def handle_cast({:add_line, start, finish}, state) do
    {:noreply, state ++ [%{start: start, end: finish}]}
  end

  def handle_call(:get_lines, _from, state) do
    {:reply, state, state}
  end
end
