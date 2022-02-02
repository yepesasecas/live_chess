defmodule LiveChessWeb.TableLive do
  use LiveChessWeb, :live_view
  require Integer
  require Logger
  alias LiveChess.{Chess, LiveGamesServer}

  def mount(%{"name" => table_name} = params, _session, socket) do
    player =
      Chess.new_player()
      |> Chess.change_player(%{name: Map.get(params, "player_name", "Anonymus")})
      |> Chess.apply_changes_to_player()

    table =
      case connected?(socket) do
        true ->
          LiveChessWeb.Endpoint.subscribe(LiveGamesServer.topic(table_name))
          LiveGamesServer.get(table_name)

        false ->
          LiveGamesServer.current_or_new(params, player)
      end
    socket =
      socket
      |> assign(table: table)
      |> assign(self: player)
      |> assign(from_square: nil)
      |> assign(error_msg: nil)

    {:ok, socket}
  end

  def handle_event("click_square", %{"selected_square" => selected_square}, socket) do
    socket =
      if socket.assigns[:from_square] == nil do
        assign(socket, from_square: selected_square)
      else
        table = socket.assigns[:table]
        from_square = socket.assigns[:from_square]
        move = Chess.new_move(from: from_square, to: selected_square)

        case LiveGamesServer.play(table.name, move) do
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
    table = socket.assigns[:table]
    LiveGamesServer.new(%{"name" => table.name})

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
