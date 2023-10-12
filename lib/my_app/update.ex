defmodule MyApp.Update do

  import Ecto.Query
  alias MyApp.Update.Repo
  alias MyApp.Update.Post



  def subscribe do
    Phoenix.PubSub.subscribe(MyApp.PubSub, "event")
  end

  def broadcast_up do
    Phoenix.PubSub.broadcast(MyApp.PubSub, "event", {:up})
    {:ok, :up}
  end

  def  broadcast_draw_line(start, ending_point) do
    Phoenix.PubSub.broadcast(MyApp.PubSub, "event", {:draw_line, start, ending_point})
  end

  def broadcast_down do
    Phoenix.PubSub.broadcast(MyApp.PubSub, "event", {:down})
    {:ok, :down}
  end

  def broadcast_reset do
    Phoenix.PubSub.broadcast(MyApp.PubSub, "event", {:reset})
    {:ok, :reset}
  end
end
