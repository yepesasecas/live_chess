# LiveChess
Create a free, ad-free, and open-source internet chess server where anyone in the world can play online chess and we can practice elixir, phoenix and liveView. (LiveChess.. LiveView. you got it).

This project is inspired by [lichess.org](http://lichess.org). Lichess.org has created an awesome free and open-source project and community.

also, inspired by the elixir community. I know, we can create a really awesome online chess server using Elixir, Phoenix and LiveView.

**project status:** Alpha. Anyone is welcome to contribute.

**links to production:** TODO

TODO screenshots

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

**TODO** Show users how to use the software. Be specific. Use appropriate formatting when showing code snippets.

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