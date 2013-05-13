class ApplicationController < ActionController::Base
  doorkeeper_for :all

  include Restaurant::ControllerHelper

  protect_from_forgery

  respond_to :json
end
