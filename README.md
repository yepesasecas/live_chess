# LiveChess
Create a free, ad-free, and open-source internet chess server where anyone in the world can play online chess and we can practice elixir, phoenix and liveView. (LiveChess.. LiveView. you got it).

This project is inspired by [lichess.org](http://lichess.org). Lichess.org has created an awesome free and open-source project and community.

also, inspired by the elixir community. I know, we can create a really awesome online chess server using Elixir, Phoenix and LiveView.

**project status:** Alpha. Anyone is welcome to contribute.

**links to production:** https://livechess.gigalixirapp.com

<img width="1440" alt="Screen Shot 2022-02-05 at 9 00 30 PM" src="https://user-images.githubusercontent.com/1679292/152665200-bddaf78b-2b0a-4817-b476-6b18ec3bfe14.png">

## Dependencies

  1. Elixir
  2. Phoenix
  3. PostgreSQL

## Installation

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Configuration

**TODO** If the software is configurable, describe it in detail, either here or in other documentation to which you link.

## Usage

1. To create a table you have two options:
  1. use the url and change TABLE_NAME for any name you want. `https://livechess.gigalixirapp.com/table/TABLE_NAME`
  2. go to `https://livechess.gigalixirapp.com/`. fill in you player name and click 'Create table'

2. You are redirected to the game table. and waiting for your opponent to arrive.
3. Share the url with your friends. or open the url in other browser.
4. now you can start playing.

### Setup you player's name
1. You can setup your player name by passing the parameter `player_name=MY_NICKNAME`. Example: `https://livechess.gigalixirapp.com/table/TABLE_NAME?player_name=MY_NICKNAME`

## How to test

[![Coverage Status](https://coveralls.io/repos/github/yepesasecas/live_chess/badge.svg?branch=main)](https://coveralls.io/github/yepesasecas/live_chess?branch=main)

  Run test with coverage
  `$  MIX_ENV=test mix do coveralls.json`

  Run test with coverate and HTML review
  `$ MIX_ENV=test mix coveralls.html ; open cover/excoveralls.html`

  Run tests
  `$ mix test`


## Known issues

Everything!

## Getting help

If you have questions, concerns, bug reports, etc, please file an issue in this repository's Issue Tracker.

## Getting involved

Fork the project, add new features, fix bugs and create a pull request.

Some features to implement:
  1. Better UI/UX.
  2. Responsive board.
  3. Clock time.
  4. A 'waiting player to start match' loading page.
  5. and, lots of other things I can't think in this moment.


# Credits and references
  * https://codepen.io/viethoang012/pen/xRNgyM
  * [lichess.org](http://lichess.org). Inspiration to create **LiveChess**
  * deployment guide: https://staknine.com/deploy-phoenix-to-gigalixir-using-elixir-releases/