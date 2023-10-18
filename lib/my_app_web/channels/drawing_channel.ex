defmodule MyAppWeb.DrawingChannel do
  use Phoenix.Channel

  def handle_in("draw", payload, socket) do
    broadcast(socket, "draw", payload)
    {:noreply, socket}
  end
end
