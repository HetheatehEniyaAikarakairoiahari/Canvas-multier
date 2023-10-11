defmodule MyAppWeb.LightLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: MyApp.Update.subscribe()

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
    {:noreply, push_event(socket, "new_line", %{start: start, end: ending_point})}
  end

  def handle_info({:draw_line, start, ending_point}, socket) do
    {:noreply, push_event(socket, "new_line", %{start: start, end: ending_point})}
  end
end
