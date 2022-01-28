defmodule LiveChessWeb.Counter do
  use Phoenix.LiveView

  alias LiveChess.Count

  @topic Count.topic()

  def mount(_params, _session, socket) do
    LiveChessWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, val: Count.current())}
  end

  def handle_event("inc", _, socket) do
    Count.incr()
    {:noreply, socket}
  end

  def handle_event("dec", _, socket) do
    Count.decr()
    {:noreply, socket}
  end

  def handle_info({:count, count}, socket) do
    {:noreply, assign(socket, val: count)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>The count is: <%= @val %></h1>
      <button phx-click="dec">-</button>
      <button phx-click="inc">+</button>
    </div>
    """
  end
end
