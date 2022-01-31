defmodule LiveChessWeb.GameLive
 do
  use LiveChessWeb, :live_view
  require Integer

  alias LiveChess.{LiveGamesServer, Chessboard, Move}

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
        move = %Move{from: from_square, to: selected_square}
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


  # private

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
      <div phx-click="click_square" phx-value-selected_square={Chessboard.square_pgn(i)} class={Chessboard.square_color(i)}></div>
    """
  end

  defp render_square(assigns, square, i) do
    ~H"""
    <div phx-click="click_square" phx-value-selected_square={Chessboard.square_pgn(i)} class={Chessboard.square_color(i)}>
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
