Rails.application.routes.draw do

  mount Restaurant::Engine => "/restaurant"
end
