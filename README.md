# Restaurant
Restaurant serves your data via auto-defined RESTful API on your rails application.

## Usage
```
$ rails new example
$ cd example

$ vi Gemfile
source "https://rubygems.org"
gem "rails", "~> 3.2.13"
gem "restaurant"
gem "sqlite3"

$ vi config/routes.rb
Example::Application.routes.draw do
  Restaurant::Router.route(self)
end

$ brew install mongodb
$ mongod --fork

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

## More
See [the example application](https://github.com/r7kamura/restaurant/tree/master/spec/dummy).
