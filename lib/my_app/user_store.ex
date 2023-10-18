defmodule MyApp.UserStore do
    def start_link(initial_value) do
        Agent.start_link(fn -> initial_value end, name: __MODULE__)
      end
    
      def update_canvas(new_state) do
        # Update the agent state with the new canvas state
        Agent.update(__MODULE__, fn _old_state -> new_state end)
    
        # Notify other processes about the updated canvas
        MyApp.PubSub.broadcast({:canvas_updated, new_state})
      end
    
      def get_canvas() do
        Agent.get(__MODULE__, & &1)
      end
end