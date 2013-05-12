class ApplicationController < ActionController::Base
  include Restaurant::AcceptDefault
  include Restaurant::ControllerProvider
  include Restaurant::ModelClassFinder
  include Restaurant::RestfulActions

  protect_from_forgery

  respond_to :json
end
