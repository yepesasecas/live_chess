defmodule LiveChess.Chess.Move do
  defstruct [from: nil, to: nil]

  def valid?(move) do
    if move.from != nil && move.to != nil do
      true
    else
      false
    end
  end

  def to_string(move) do
   "#{move.from}-#{move.to}"
  end 
end