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

  def handle_call({:current_or_new, table_name}, _from, tables) do
    new_table = Map.get(tables, table_name, Chess.new_table(name: table_name))
    tables = Map.put(tables, table_name, new_table)
    {:reply, new_table, tables}
  end

  def handle_call({:new, table_name}, _from, tables) do
    new_table = Chess.new_table()
    tables = Map.put(tables, table_name, new_table)
    PubSub.broadcast(LiveChess.PubSub, topic(table_name), {:new_table, new_table})
    {:reply, new_table, tables}
  end

  def handle_call({:get, table_name}, _from, tables) do
    {:reply, Map.get(tables, table_name), tables}
  end

  def handle_call({:play, table_name, move}, _from, tables) do
    table = Map.get(tables, table_name)
    case Chess.game_play(table, move) do
      {:ok, updated_table} ->
        PubSub.broadcast(LiveChess.PubSub, topic(table_name), {:played, updated_table})
        tables = Map.put(tables, table_name, updated_table)
        {:reply, {:ok, updated_table}, tables}
      {:error, msg} ->
        {:reply, {:error, msg}, tables}
    end
  end
end
