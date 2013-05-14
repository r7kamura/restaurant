class ApplicationController < ActionController::Base
  include Restaurant::ControllerHelper

  protect_from_forgery
end
