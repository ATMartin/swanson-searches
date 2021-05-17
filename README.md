# Swanson Searches

-- 🥓🍳🥞🌲🌲🛶 --

Search for popular Ron Swanson quotes and see what other users have searched for, too!

#### Try this app out on Heroku at https://swanson-leaderboard.herokuapp.com/.


## API

🕵️ Check out our [OpenAPI docs](https://petstore.swagger.io/?url=https://swanson-leaderboard.herokuapp.com/openapiv3.yml) for interactive examples of the available API.

Here's a short summary of available endpoints:

```
GET /searches
   -- Returns a list of saved searches & associated results.
      May be `filter`ed by query or `sort`ed alternatively using querystring params.
      Ex: /searches?filter=bacon&sort=desc

POST /searches
   -- Creates a new search or returns an existing search based on the given `query` value.
      Requires a body like `{"query": "your-query-string-here"}`.

GET /searches/:id
   -- Returns a specific search & associated result by its numeric ID.
```

We recommend [Postman](https://www.postman.com/) for exploring the API.


## Setup & Details

This app is built on Ruby 2.7.2 & Rails 6.1.3.2 and stores data in Postgres 13.

It's a thin wrapper around the [Ron Swanson Quotes API](https://github.com/jamesseanwright/ron-swanson-quotes).

To set it up locally, you'll need [PostgreSQL](https://www.postgresql.org/) installed & running.
> We've included a [Docker](https://www.docker.com/) file to help you get going fast, if needed!

Commands to kick things off:

```sh
# Only needed if using Docker for PostgreSQL
docker compose up -d

bundle install
rails db:setup
rails server
```


## Tests

Automated tests are built using [Minitest](https://guides.rubyonrails.org/testing.html#rails-meets-minitest), the Rails default.
To run the entire suite:

```
rails test
```


## Opportunities for Improvement

<details>
  <summary>🧶 Tight integration with Postgres</summary>
  <p>
    This app is built to use the <code>ARRAY</code> data type and includes the <code>ILIKE</code> SQL operator, both of
    which have limited support outside of Postgres. It might be nice to replace these with an alternative implementation
    that could make the API database-agnostic.
  </p>
</details>

<details>
  <summary>🔓 No auth*tion</summary>
  <p>
    That's right: this is an entirely open API at the moment. This poses a slew of problems, including the risk of serious
    abuse. At its simplest, a protective layer may involve a quick hash provisioned for users by email & required in the
    query params. Going further, a proper auth system likely involves OAuth + third party authentication, abuse & spam reporting,
    and maybe a tiered subscription plan for folks with heavy query needs? The sky's the limit!
  </p>
</details>

<details>
  <summary>🎈 Size concerns</summary>
  <p>
    We're not restricting query behavior here, which opens us up to attacks via massive payloads, high request rates, or both!
    This will quickly max out our database limitations and could put our source API at risk as well. Since this is a silly
    hobby project, we're relying on Heroku to shut down if overloaded. In a production environment with data that matters,
    we'd want to consider rate limiting, tighter database constraints, and more thorough validations on our controller endpoints.
  </p>
</details>
