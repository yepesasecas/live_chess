# LiveChess

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

# Credits
  * https://codepen.io/viethoang012/pen/xRNgyM

# Test
  Run test with coverage
  `$  MIX_ENV=test mix do coveralls.json`

  Run test with coverate and HTML review
  `$ MIX_ENV=test mix coveralls.html ; open cover/excoveralls.html`

  Run tests
  `$ mix test`

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
