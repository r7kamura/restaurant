module V2
  class ResourcesController < ApplicationController
    include Restaurant::Actions

    respond_to :json

    doorkeeper_for :all
  end
end
