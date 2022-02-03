defmodule LiveChess.Chess.Fen do
  alias LiveChess.Chess.Fen

  defstruct piece_placement: nil,
            active_color: nil,
            castling_availability: nil,
            en_passant: nil,
            halfmove_clock: nil,
            fullmove_number: nil

  def from_string(fen_string) do
    [
      piece_placement
      | [
          active_color
          | [castling_availability | [en_passant | [halfmove_clock | [fullmove_number]]]]
        ]
    ] = String.split(fen_string)

    %Fen{
      piece_placement: piece_placement,
      active_color: active_color,
      castling_availability: castling_availability,
      en_passant: en_passant,
      halfmove_clock: halfmove_clock,
      fullmove_number: fullmove_number
    }
    |> add_piece_placement()
    |> add_active_color()
  end

  defp add_piece_placement(%Fen{piece_placement: piece_placement_string} = fen) do
    piece_placement =
      piece_placement_string
      |> String.replace("/", "")
      |> String.graphemes()
      |> replace_empty_squares()
      |> List.flatten()

    %{fen | piece_placement: piece_placement}
  end

  defp add_active_color(%Fen{active_color: "w"} = fen), do: %{fen | active_color: :white}

  defp add_active_color(%Fen{active_color: "b"} = fen), do: %{fen | active_color: :black}

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
end
