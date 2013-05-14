# Restaurant
Restraunt serves your data via auto-defined RESTful API on your rails application.

## controller-less & route-less
Restaurant provides strict RESTful API implementation for your models.
All controllers and routes will be auto-defined based on your config/restaurant.yml definition.
No need to write any more app/controllers and config/routes.rb.
All you have to do is write your models and authorization yaml file.

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Restaurant::ControllerHelper
end
```

```ruby
# config/routes.rb
Rails.application.routes.draw do
  Restaurant::Router.route(self)
end
```

```yaml
# config/restaurant.yml
public:
  recipes:
    actions:
      - index
      - show
  users:
    actions:
      - show
```

## Authorization
You can restrict users by scopes, actions, attributes, and queries.

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
Our restraunt serves SQL-like URI query system.

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

## More
See [the example application](https://github.com/r7kamura/restaurant/tree/master/spec/dummy).
