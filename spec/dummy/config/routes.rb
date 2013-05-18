Rails.application.routes.draw do
  use_doorkeeper

  namespace :v1 do
    Restaurant::Router.route(self)
  end

  namespace :v2 do
    Restaurant::Router.route(self)
  end
end
