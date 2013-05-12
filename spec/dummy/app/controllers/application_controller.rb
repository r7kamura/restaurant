class ApplicationController < ActionController::Base
  include Restaurant::ModelClassFinder

  protect_from_forgery
end
