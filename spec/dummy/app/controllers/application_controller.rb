class ApplicationController < ActionController::Base
  include Restaurant::ModelClassFinder
  include Restaurant::RestfulActions

  protect_from_forgery
end
