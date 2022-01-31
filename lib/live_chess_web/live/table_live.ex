defmodule LiveChessWeb.TableLive
 do
  use LiveChessWeb, :live_view
  require Integer

  alias LiveChess.{Chess, LiveGamesServer}

  def mount(%{"name" => table_name}, _session, socket) do
    socket = 
      socket
      |> assign(table: LiveGamesServer.current_or_new(table_name))
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
    LiveGamesServer.new(table_name)
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
    ~H"""
    <%= render_chessboard(assigns) %>
    <h1>Table: <%= @table_name%></h1>
    <div>error_msg: <%= @error_msg %></div>
    <div>from: <%= @from_square %></div>
    <div>game check: <%= @table.game.check %></div>
    <div>game fen: <%= @table.game.current_fen %></div>
    <div>game status: <%= @table.game.status %></div>
    <div>white player: <%= @table.white_player %></div>
    <div>black player: <%= @table.black_player %></div>
    <div>
      <button id="new_game" phx-click="new_game">new game</button>
    </div>
    """
  end


  # private

  defp render_chessboard(assigns) do
    [fen | _] = String.split(assigns[:table].game.current_fen)
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
      <div phx-click="click_square" phx-value-selected_square={Chess.board_square_pgn(i)} class={Chess.board_square_color(i)}></div>
    """
  end

  defp render_square(assigns, square, i) do
    ~H"""
    <div phx-click="click_square" phx-value-selected_square={Chess.board_square_pgn(i)} class={Chess.board_square_color(i)}>
      <img src={Routes.static_path(@socket, "/images/#{piece_image_name(square)}.png")}>
    </div>
    """
  end  

  # helpers

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

  defp piece_image_name(square) do
    if square == String.upcase(square) do
      "white_#{square}"
    else
      "black_#{square}"
    end
  end
end
