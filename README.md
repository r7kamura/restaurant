# Restaurant
Restaurant serves your data via auto-defined RESTful API on your rails application.

## Features
* Auto-defined models
* Auto-defined controllers
* Auto-defined routes
* SQL-like URI query
* OAuth authentication
* Scope based authorization
 * restrict actions
 * restrict attributes
 * restrict filtering
 * restrict sorting
* RESTful APIs
 * GET /:resources
 * GET /:resources/:id
 * POST /:resources
 * PUT /:resources/:id
 * DELETE /:resources/:id

## Auto-defined application
Models, controllers, and routes are auto-defined from your config/restaurant.yml.

```yaml
# config/restaurant.yml
public:         # User with "public" scope token
  recipes:      #
    actions:    #
      - show    # can access to /recipes/:id
    attributes: #
      - title   # can read recipe.title
admin:          # User with "admin" scope token
  recipes:      #
    actions:    #
      - index   # can access to /recipes
      - show    # can access to /recipes/:id
    where:      #
      - id      # can filter recipes by id
      - title   # can filter recipes by title
    order:      #
      - id      # can sort recipes by id
      - title   # can sort recipes by title
    attributes: #
      - id      # can read recipe.id
      - title   # can read recipe.title
```

## SQL-like URI query
You can filter and sort resources by SQL-like URI query.

```ruby
context "with where params" do
  it "returns recipes filtered by given query" do
    get "/recipes", { where: { title: { eq: recipe.title } } }, env
    response.should be_ok
    response.body.should be_json(
       "id"         => 1,
       "user_id"    => 1
       "body"       => "body 1",
       "title"      => "title 1",
       "updated_at" => "2000-01-01T00:00:00Z",
       "created_at" => "2000-01-01T00:00:00Z",
    )
  end
end
```

## Install
```ruby
# Gemfile
gem "restaurant"

# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Restaurant::ControllerHelper
end

# config/routes.rb
Rails.application.routes.draw do
  Restaurant::Router.route(self)
end
```

```
$ bundle install
$ bundle exec rails g doorkeeper:install
$ bundle exec rails g doorkeeper:migration
$ bundle exec rake db:migrate
```

## More
See [the example application](https://github.com/r7kamura/restaurant/tree/master/spec/dummy).
