defmodule LiveChessWeb.GameLive
 do
  use LiveChessWeb, :live_view
  require Integer

  alias LiveChess.LiveGamesServer

  def mount(%{"table_name" => table_name}, _session, socket) do
    socket = 
      socket
      |> assign(game: LiveGamesServer.current_or_new(table_name))
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
        move = %LiveChess.Move{from: from_square, to: selected_square}
        case LiveGamesServer.play(table_name, move) do
          {:ok, game} ->  
            socket
            |> assign(game: game)
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
    LiveGamesServer.new(table_name)
    socket =
      socket
      |> assign(from_square: nil)
      |> assign(error_msg: nil)
    {:noreply, socket}
  end

  def handle_info({:new_game, game}, socket) do
    socket =
      socket
      |> assign(game: game)
      |> assign(from_square: nil)
      |> assign(error_msg: nil)
    {:noreply, socket}
  end

  def handle_info({:played, game}, socket) do
    {:noreply, assign(socket, game: game)}
  end

  def render(assigns) do
    ~H"""
    <%= render_chessboard(assigns) %>
    <div>error_msg: <%= @error_msg %></div>
    <div>from: <%= @from_square %></div>
    <div>game check: <%= @game.check %></div>
    <div>game fen: <%= @game.current_fen %></div>
    <div>game status: <%= @game.status %></div>
    <div>
      <button phx-click="new_game">new game</button>
    </div>
    """
  end

  defp render_chessboard(assigns) do
    [fen | _] = String.split(assigns[:game].current_fen)
    squares =
      fen
      |> String.replace("/", "")
      |> String.graphemes()
      |> replace_empty_squares()
      |> List.flatten
    ~H"""
    <div class="chessboard">
      <%= for {square, i} <- Enum.with_index(squares) do%>
        <%= render_square(assigns, square, i) %>
      <% end %>
    </div>
    """
  end

  defp render_square(assigns, "empty", i) do
    ~H"""
      <div phx-click="click_square" phx-value-selected_square={square_pgn(i)} class={square_color(i)}></div>
    """
  end

  defp render_square(assigns, square, i) do
    ~H"""
    <div phx-click="click_square" phx-value-selected_square={square_pgn(i)} class={square_color(i)}>
      <img src={Routes.static_path(@socket, "/images/#{piece_image_name(square)}.png")}>
    </div>
    """
  end  

  # Helpers

  defp replace_empty_squares(squares) do
    Enum.map(squares, fn square -> 
      case Integer.parse(square) do
        :error ->
          square
        {value, _} ->
          ["empty"] |> List.duplicate(value) |> List.flatten
      end
    end)
  end

  defp square_color(i) do
    colors = [
      "black", "white", "black", "white", "black", "white", "black", "white",
      "white", "black", "white", "black", "white", "black", "white", "black",
      "black", "white", "black", "white", "black", "white", "black", "white",
      "white", "black", "white", "black", "white", "black", "white", "black",
      "black", "white", "black", "white", "black", "white", "black", "white",
      "white", "black", "white", "black", "white", "black", "white", "black",
      "black", "white", "black", "white", "black", "white", "black", "white",
      "white", "black", "white", "black", "white", "black", "white", "black",
    ]
    Enum.at(colors, i)
  end

  defp square_pgn(i) do
    pgn = [
      "a8", "b8", "c8", "d8", "e8", "f8", "g8", "h8",
      "a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7",
      "a6", "b6", "c6", "d6", "e6", "f6", "g6", "h6", 
      "a5", "b5", "c5", "d5", "e5", "f5", "g5", "h5", 
      "a4", "b4", "c4", "d4", "e4", "f4", "g4", "h4", 
      "a3", "b3", "c3", "d3", "e3", "f3", "g3", "h3", 
      "a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2", 
      "a1", "b1", "c1", "d1", "e1", "f1", "g1", "h1",  
    ]
    Enum.at(pgn, i)
  end

  defp piece_image_name(square) do
    if square == String.upcase(square) do
      "white_#{square}"
    else
      "black_#{square}"
    end
  end
end
