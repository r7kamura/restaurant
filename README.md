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
You can restrict users by their scopes, accessed actions, and used queries.

* User with "public" scope token
 * can access /recipes/:id
* User with "admin" scope token
 * can access /recipes/:id
 * can access /recipes
 * can filter recipes by id and title
 * can sort recipes by id and title

```yaml
# config/restaurant.yml
public:
  recipes:
    actions:
      - show
admin:
  recipes:
    actions:
      - index
      - show
    where:
      - id
      - title
    order:
      - id
      - title
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
