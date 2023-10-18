defmodule MyAppWeb.UserSocket do
  use Phoenix.Socket

  channel "drawing:canvas", MyAppWeb.DrawingChannel
end
