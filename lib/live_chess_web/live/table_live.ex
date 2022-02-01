defmodule LiveChessWeb.TableLive do
  use LiveChessWeb, :live_view
  require Integer

  alias LiveChess.{Chess, LiveGamesServer}

  def mount(params, _session, socket) do
    %{"name" => table_name} = params
    table = LiveGamesServer.current_or_new(params)

    socket =
      socket
      |> assign(table: table)
      |> assign(table_name: table_name)
      |> assign(from_square: nil)
      |> assign(error_msg: nil)

    LiveChessWeb.Endpoint.subscribe(LiveGamesServer.topic(table_name))
    {:ok, socket}
  end

  def handle_event("click_square", %{"selected_square" => selected_square}, socket) do
    socket =
      if socket.assigns[:from_square] == nil do
        assign(socket, from_square: selected_square)
      else
        table_name = socket.assigns[:table_name]
        from_square = socket.assigns[:from_square]
        move = Chess.new_move(from: from_square, to: selected_square)

        case LiveGamesServer.play(table_name, move) do
          {:ok, table} ->
            socket
            |> assign(table: table)
            |> assign(from_square: nil)
            |> assign(error_msg: nil)

          {:error, msg} ->
            socket
            |> assign(error_msg: msg)
            |> assign(from_square: nil)
        end
      end

    {:noreply, socket}
  end

  def handle_event("new_game", _params, socket) do
    table_name = socket.assigns[:table_name]
    LiveGamesServer.new(%{"name" => table_name})

    socket =
      socket
      |> assign(from_square: nil)
      |> assign(error_msg: nil)

    {:noreply, socket}
  end

  def handle_info({:new_table, table}, socket) do
    socket =
      socket
      |> assign(table: table)
      |> assign(from_square: nil)
      |> assign(error_msg: nil)

    {:noreply, socket}
  end

  def handle_info({:played, table}, socket) do
    {:noreply, assign(socket, table: table)}
  end

  def render(assigns) do
    LiveChessWeb.TableLiveView.render("chess_game.html", assigns)
  end
end
