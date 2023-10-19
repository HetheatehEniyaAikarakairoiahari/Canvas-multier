defmodule MyAppWeb.LightLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: MyApp.Update.subscribe()
    a = Process.whereis(:wow)
    send(a, {:get_state, self()})
    # Assign a random ID to each player's drawing
    socket
    |> assign(:lines, [])
    |> assign(:drawing_id, Enum.random(1..1_000_000))
    |> (&{:ok, &1}).()
  end

  def render(assigns) do
    # ...
    ~H"""
    <canvas id={"draw-board-" <> Integer.to_string(assigns.drawing_id)} phx-hook={"DrawBoard"} data-drawing-id={assigns.drawing_id} width="800" height="600" style="border:1px solid #000000;">
      #{Enum.join(lines_html)}
    </canvas>
    <script src="/assets/js/draw_board.js"></script>
    """
  end

  def handle_event("draw_line", %{"start" => start, "end" => ending_point}, socket) do
    MyApp.Update.broadcast_draw_line(start, ending_point)
    a = Process.whereis(:wow)
    send(a,{:new_event, start, ending_point})
    IO.puts("replaying #{inspect(start)}")
    {:noreply, push_event(socket, "new_line", %{start: start, end: ending_point})}
  end

  def handle_info({:draw_line, start, ending_point}, socket) do
    {:noreply, push_event(socket, "new_line", %{start: start, end: ending_point})}
  end

  def handle_info({:get_state, state}, socket) do
    IO.puts("state #{inspect(state)}")
    #state_replay(state, socket)
    state = Enum.map(state, fn {map1, map2} -> [map1, map2] end)
    {:noreply, push_event(socket, "replay_canvas", %{list: state})}
  end

  def state_replay([], socket) do
    IO.puts("end of replay")
    socket
  end

  def state_replay([head|tail], socket) do

    {start, finish} = head
    #state_replay(tail, socket)
    push_event(socket, "new_line", %{start: start, end: finish})
    #state_replay(tail, socket)
  end

  def state_replay(var, socket) do
    IO.puts("unhandled: #{inspect(var)}")
  end
end
