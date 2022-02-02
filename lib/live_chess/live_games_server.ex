defmodule LiveChess.LiveGamesServer do
  use GenServer

  alias Phoenix.PubSub
  alias LiveChess.Chess
  alias LiveChess.Chess.Player

  @name :games_server

  @start_value %{}

  # -------  External API (runs in client process) -------
  def all_tables_topic do
    "game_server:all"
  end

  def topic(table_name) do
    "game_server:#{table_name}"
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, @start_value, name: @name)
  end

  def init(start_value) do
    {:ok, start_value}
  end

  def current_or_new(table_params, player) do
    GenServer.call(@name, {:current_or_new, table_params, player})
  end

  def new(table_name) do
    GenServer.call(@name, {:new, table_name})
  end

  def get(table_name) do
    GenServer.call(@name, {:get, table_name})
  end

  def get_all() do
    GenServer.call(@name, :get_all)
  end

  def play(table_name, move) do
    GenServer.call(@name, {:play, table_name, move})
  end

  # -------  Implementation  (Runs in GenServer process) -------

  def handle_call({:current_or_new, table_params, player}, _from, tables) do
    table_name = Map.get(table_params, "name")

    table =
      case Map.get(tables, table_name) do
        nil ->
          Chess.new_table(name: table_name)
          |> Chess.add_player(:white, player)

        table ->
          Chess.add_player(table, :black, player)
      end

    tables = Map.put(tables, table_name, table)
    PubSub.broadcast(LiveChess.PubSub, topic(table_name), {:played, table})
    PubSub.broadcast(LiveChess.PubSub, all_tables_topic(), {:all_tables, tables})
    {:reply, table, tables}
  end

  def handle_call({:new, table_params}, _from, tables) do
    table_name = Map.get(table_params, "name")
    player_name = Map.get(table_params, "player_name", "Anonymus")
    table =
      tables
      |> Map.get(table_name)
      |> Chess.table_new_game()
    tables = Map.put(tables, table_name, table)

    PubSub.broadcast(LiveChess.PubSub, topic(table_name), {:new_table, table})
    PubSub.broadcast(LiveChess.PubSub, all_tables_topic(), {:all_tables, tables})

    {:reply, table, tables}
  end

  def handle_call({:get, table_name}, _from, tables) do
    {:reply, Map.get(tables, table_name), tables}
  end

  def handle_call(:get_all, _from, tables) do
    {:reply, tables, tables}
  end

  def handle_call({:play, table_name, move}, _from, tables) do
    table = Map.get(tables, table_name)

    case Chess.game_play(table, move) do
      {:ok, updated_table} ->
        PubSub.broadcast(LiveChess.PubSub, topic(table_name), {:played, updated_table})
        PubSub.broadcast(LiveChess.PubSub, all_tables_topic(), {:all_tables, tables})
        tables = Map.put(tables, table_name, updated_table)
        {:reply, {:ok, updated_table}, tables}

      {:error, msg} ->
        {:reply, {:error, msg}, tables}
    end
  end
end
