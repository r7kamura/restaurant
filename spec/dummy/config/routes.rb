Rails.application.routes.draw do
  namespace :v1 do
    Restaurant::Router.route(self)
  end
end
