defmodule LiveChess.LiveGamesServer do
  use GenServer

  alias Phoenix.PubSub
  alias LiveChess.Chess

  @name :games_server

  @start_value %{}

  # -------  External API (runs in client process) -------
  def topic(table_name) do
    "game_server:#{table_name}"
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, @start_value, name: @name)
  end

  def init(start_value) do
    {:ok, start_value}
  end

  def current_or_new(table_name) do
    GenServer.call(@name, {:current_or_new, table_name})
  end

  def new(table_name) do
    GenServer.call(@name, {:new, table_name})
  end

  def get(table_name) do
    GenServer.call(@name, {:get, table_name})
  end

  def play(table_name, move) do
    GenServer.call(@name, {:play, table_name, move})
  end

  # -------  Implementation  (Runs in GenServer process) -------

  def handle_call({:current_or_new, table_name}, _from, games) do
    new_game = Map.get(games, table_name, Chess.new_game())
    games = Map.put(games, table_name, new_game)
    {:reply, new_game, games}
  end

  def handle_call({:new, table_name}, _from, games) do
    new_game = Chess.new_game()
    games = Map.put(games, table_name, new_game)
    PubSub.broadcast(LiveChess.PubSub, topic(table_name), {:new_game, new_game})
    {:reply, new_game, games}
  end

  def handle_call({:get, table_name}, _from, games) do
    {:reply, Map.get(games, table_name), games}
  end

  def handle_call({:play, table_name, move}, _from, games) do
    game = Map.get(games, table_name)
    case Chess.game_play(game, move) do
      {:ok, updated_game} ->
        PubSub.broadcast(LiveChess.PubSub, topic(table_name), {:played, updated_game})
        games = Map.put(games, table_name, updated_game)
        {:reply, {:ok, updated_game}, games}
      {:error, msg} ->
        {:reply, {:error, msg}, games}
    end
  end
end
