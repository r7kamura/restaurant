class ApplicationController < ActionController::Base
  include Restaurant::ControllerHelper

  protect_from_forgery

  respond_to :json
end
