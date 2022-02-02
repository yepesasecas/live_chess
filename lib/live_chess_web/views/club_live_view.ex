defmodule LiveChessWeb.ClubLiveView do
  use LiveChessWeb, :view
  alias LiveChess.Chess.Player

  def has_player?(nil), do: ""
  def has_player?(%Player{name: name}), do: name
end
