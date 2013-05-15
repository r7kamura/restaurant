# Restaurant
Restaurant serves your data via auto-defined RESTful API on your rails application.  
All you have to do is to write config/restaurant.yml and create DB tables.

## Features
* Auto-defined models
* Auto-defined controllers
* Auto-defined routes
* Versioning
* SQL-like URI query
* OAuth authentication
* Scope based authorization
 * restrict actions
 * restrict attributes
 * restrict filtering
 * restrict sorting
* RESTful APIs
 * GET /v1/:resources
 * GET /v1/:resources/:id
 * POST /v1/:resources
 * PUT /v1/:resources/:id
 * DELETE /v1/:resources/:id

## Auto-defined application
Models, controllers, and routes are auto-defined from your config/restaurant.yml.

```yaml
# config/restaurant.yml
v1:               # Namespaced by v1
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
    get "/v1/recipes", { where: { title: { eq: recipe.title } } }, env
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

## Usage
```ruby
# Gemfile
gem "restaurant"
```

```
$ bundle install
$ bundle exec rails g doorkeeper:install
$ bundle exec rails g doorkeeper:migration
$ bundle exec rake db:migrate
$ ... write your config/restaurant.yml ...
$ ... create your db and tables ...
$ ... issue acceess tokens for your clients ...
$ rails c
irb(main):001:0> app.get "/v1/recipes?access_token=411bb7ec00076a740c5d8ef8832195ae131270829cdbe3f3d24520970a620058"
=> 200
```

## More
See [the example application](https://github.com/r7kamura/restaurant/tree/master/spec/dummy).
