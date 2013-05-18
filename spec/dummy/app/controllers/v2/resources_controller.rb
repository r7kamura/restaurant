module V2
  class ResourcesController < ApplicationController
    include Restaurant::Actions

    respond_to :json

    doorkeeper_for :all

    before_filter :require_authorization

    private

    def require_authorization
      head 403 unless has_authorization?
    end

    def roles
      Mongoid.default_session["roles"]
    end

    def has_authorization?
      doorkeeper_token.scopes.any? do |scope|
        if role = roles.find(:scope => scope).first
          if action_names = role[resources_name]
            action_names.include?(action_name)
          end
        end
      end
    end
  end
end
