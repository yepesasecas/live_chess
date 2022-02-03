defmodule LiveChessWeb.TableLiveView do
  use LiveChessWeb, :view
  alias LiveChess.Chess
  alias LiveChess.Chess.{Table, Player}

  def render_white_chessboard(assigns) do
    ~H"""
    <div class="chessboard">
      <h1>White view</h1>
      <%= for {square, i} <- piece_placement(assigns[:table]) do%>
        <%= render_white_square(assigns, square, i) %>
      <% end %>
    </div>
    """
  end

  def render_black_chessboard(assigns) do
    ~H"""
    <h1>Black view</h1>
    <div class="chessboard">=
      <%= for {square, i} <- piece_placement(:black, assigns[:table]) do%>
        <%= render_black_square(assigns, square, i) %>
      <% end %>
    </div>
    """
  end

  def render_viewer_chessboard(assigns) do
    ~H"""
    <h1>Viewer view</h1>
    <div class="chessboard">
      <%= for {square, i} <- piece_placement(assigns[:table]) do%>
        <%= render_white_square(assigns, square, i) %>
      <% end %>
    </div>
    """
  end

  defp render_white_square(assigns, "empty", i) do
    ~H"""
    <div phx-click="click_square"
         phx-value-selected_square={Chess.board_square_pgn(i)}
         class={square_clasess(i, assigns.table)}>
    </div>
    """
  end

  defp render_white_square(assigns, square, i) do
    ~H"""
    <div phx-click="click_square"
         phx-value-selected_square={Chess.board_square_pgn(i)}
         class={square_clasess(i, assigns.table)}>
            <img src={Routes.static_path(@socket, "/images/#{piece_image_name(square)}.png")}>
    </div>
    """
  end

  defp render_black_square(assigns, "empty", i) do
    ~H"""
    <div phx-click="click_square"
         phx-value-selected_square={Chess.board_square_pgn(:black, i)}
         class={square_clasess(:black, i, assigns.table)}>
    </div>
    """
  end

  defp render_black_square(assigns, square, i) do
    ~H"""
    <div phx-click="click_square"
         phx-value-selected_square={Chess.board_square_pgn(:black, i)}
         class={square_clasess(:black, i, assigns.table)}>
      <img src={Routes.static_path(@socket, "/images/#{piece_image_name(square)}.png")}>
    </div>
    """
  end

  def has_player?(nil), do: ""
  def has_player?(%Player{name: name}), do: name

  # helpers
  defp piece_placement(:black, table) do
    table.fen.piece_placement
    |> Enum.reverse()
    |> Enum.with_index()
  end

  defp piece_placement(table) do
    table.fen.piece_placement
    |> Enum.with_index()
  end

  defp piece_image_name(square) do
    if square == String.upcase(square) do
      "white_#{square}"
    else
      "black_#{square}"
    end
  end

  defp square_clasess(i, %Table{last_move: nil}), do: Chess.board_square_color(i)

  defp square_clasess(i, %Table{last_move: move}) do
    pgn = Chess.board_square_pgn(i)

    case pgn == move.from || pgn == move.to do
      true ->
        "#{Chess.board_square_color(i)} last_move"

      false ->
        Chess.board_square_color(i)
    end
  end

  defp square_clasess(:black, i, %Table{last_move: nil}), do: Chess.board_square_color(i)

  defp square_clasess(:black, i, %Table{last_move: move}) do
    pgn = Chess.board_square_pgn(:black, i)

    case pgn == move.from || pgn == move.to do
      true ->
        "#{Chess.board_square_color(i)} last_move"

      false ->
        Chess.board_square_color(i)
    end
  end
end
