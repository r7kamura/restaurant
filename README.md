# Restaurant
Restaurant serves your data via auto-defined RESTful API on your rails application.  
No longer models, controllers, views, routes, and schema are needed.

## Usage
```
$ brew install mongodb
$ mongod --fork

$ rails new example
$ cd example

$ echo 'gem "restaurant"' >> Gemfile
$ bundle install

$ rails g mongoid:config
$ rails c

[1] pry(main)> app.accept = "application/json"
=> "application/json"
[2] pry(main)> app.post "/recipes", recipe: { title: "created" }
=> 201
[3] pry(main)> JSON.parse(app.response.body)
=> {"title"=>"created", "_id"=>"51963fe9f02da4c1f8000001"}
[4] pry(main)> app.get "/recipes/51963fe9f02da4c1f8000001"
=> 200
[5] pry(main)> JSON.parse(app.response.body)
=> {"title"=>"created", "_id"=>"51963fe9f02da4c1f8000001"}
[6] pry(main)> app.put "/recipes/51963fe9f02da4c1f8000001", recipe: { title: "updated" }
=> 204
[7] pry(main)> app.get "/recipes/51963fe9f02da4c1f8000001"
=> 200
[8] pry(main)> JSON.parse(app.response.body)
=> {"title"=>"updated", "_id"=>"51963fe9f02da4c1f8000001"}
[9] pry(main)> app.get "/recipes"
=> 200
[10] pry(main)> JSON.parse(app.response.body)
=> [{"title"=>"updated", "_id"=>"51963fe9f02da4c1f8000001"}]
[11] pry(main)> app.delete "/recipes/51963fe9f02da4c1f8000001"
=> 204
[12] pry(main)> app.get "/recipes"
=> 200
[13] pry(main)> JSON.parse(app.response.body)
=> []
```

## Customize
While Restaurant automagically defines what RESTful API needs, you can do them on your own.

### routes
```ruby
# config/routes.rb
#   1. V1::ResourcesController < ApplicationController are defined if not defined
#   2. The following routes are defined
#     GET    /v1/:resources     -> V1::ReosurcesController#index
#     GET    /v1/:resources/:id -> V1::ResourcesController#show
#     POST   /v1/:resources     -> V1::ResourcesController#create
#     PUT    /v1/:resources/:id -> V1::ResourcesController#update
#     DELETE /v1/:resources/:id -> V1::ResourcesController#destroy
namespace :v1 do
  Restaurant::Router.route(self)
end

# Or customize what you want (e.g. only provides Read API)
namespace :v2 do
  scope ":resource" do
    controller :resources do
      get "" => :index
      get ":id" => :show
    end
  end
end
```

### controller
```ruby
# Restaurant::Actions provides index, show, create, update, and destroy actions by default.
# Of course you can override them as you like.
module V1
  class ResourcesController < ApplicationController
    include Restaurant::Actions
    respond_to :xml # you can respond to xml requests

    def index
      respond_with { foo: "bar" }
    end
  end
end
```

## More
See [the example application](https://github.com/r7kamura/restaurant/tree/master/spec/dummy).
