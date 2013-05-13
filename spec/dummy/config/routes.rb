Rails.application.routes.draw do
  use_doorkeeper

  Restaurant::Router.route(self)
end
