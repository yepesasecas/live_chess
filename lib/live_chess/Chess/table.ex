defmodule LiveChess.Chess.Table do
  defstruct name: nil, white_player: nil, black_player: nil, game: nil

  alias LiveChess.Chess.{Player, Table}

  def status(%Table{white_player: nil, black_player: nil}), do: :no_players
  def status(%Table{white_player: %Player{}, black_player: nil}), do: :waiting_black_player
  def status(%Table{white_player: nil, black_player: %Player{}}), do: :waiting_white_player
  def status(%Table{white_player: %Player{}, black_player: %Player{}}), do: :playing
end
