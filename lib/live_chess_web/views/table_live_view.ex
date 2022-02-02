defmodule LiveChessWeb.TableLiveView do
  use LiveChessWeb, :view

  alias LiveChess.Chess
  alias LiveChess.Chess.Player

  def render_white_chessboard(assigns) do
    ~H"""
    <div class="chessboard">
      <h1>White view</h1>
      <%= for {square, i} <- fen_to_squares(assigns[:table].game.current_fen) do%>
        <%= render_white_square(assigns, square, i) %>
      <% end %>
    </div>
    """
  end

  def render_black_chessboard(assigns) do
    ~H"""
    <h1>Black view</h1>
    <div class="chessboard">=
      <%= for {square, i} <- fen_to_squares(:black, assigns[:table].game.current_fen) do%>
        <%= render_black_square(assigns, square, i) %>
      <% end %>
    </div>
    """
  end

  def render_viewer_chessboard(assigns) do
    ~H"""
    <h1>Viewer view</h1>
    <div class="chessboard">
      <%= for {square, i} <- fen_to_squares(assigns[:table].game.current_fen) do%>
        <%= render_white_square(assigns, square, i) %>
      <% end %>
    </div>
    """
  end

  defp render_white_square(assigns, "empty", i) do
    ~H"""
    <div phx-click="click_square" phx-value-selected_square={Chess.board_square_pgn(i)} class={Chess.board_square_color(i)}></div>
    """
  end

  defp render_white_square(assigns, square, i) do
    ~H"""
    <div phx-click="click_square" phx-value-selected_square={Chess.board_square_pgn(i)} class={Chess.board_square_color(i)}>
      <img src={Routes.static_path(@socket, "/images/#{piece_image_name(square)}.png")}>
    </div>
    """
  end

  defp render_black_square(assigns, "empty", i) do
    ~H"""
    <div phx-click="click_square" phx-value-selected_square={Chess.board_square_pgn(:black, i)} class={Chess.board_square_color(i)}></div>
    """
  end

  defp render_black_square(assigns, square, i) do
    ~H"""
    <div phx-click="click_square" phx-value-selected_square={Chess.board_square_pgn(:black, i)} class={Chess.board_square_color(i)}>
      <img src={Routes.static_path(@socket, "/images/#{piece_image_name(square)}.png")}>
    </div>
    """
  end

  def has_player?(nil), do: ""
  def has_player?(%Player{name: name}), do: name

  # helpers
  defp fen_to_squares(:black, fen) do
    [fen | _] = String.split(fen)

    fen
    |> String.reverse()
    |> fen_to_squares()
  end

  defp fen_to_squares(fen) do
    [fen | _] = String.split(fen)

    fen
    |> String.replace("/", "")
    |> String.graphemes()
    |> replace_empty_squares()
    |> List.flatten()
    |> Enum.with_index()
  end

  defp replace_empty_squares(squares) do
    Enum.map(squares, fn square ->
      case Integer.parse(square) do
        :error ->
          square

        {value, _} ->
          ["empty"] |> List.duplicate(value) |> List.flatten()
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
