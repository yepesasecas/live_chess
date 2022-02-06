defmodule LiveChessWeb.Plugs.PlayerUuid do
  import Plug.Conn

  alias LiveChess.Chess.Player

  def init(init_param), do: init_param

  def call(conn, _init_param) do
    case get_session(conn, :player_uuid) do
      nil ->
        put_session(conn, :player_uuid, Player.uuid())
      player_uuid ->
        conn
    end
  end
end