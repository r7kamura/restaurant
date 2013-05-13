module Restaurant::Authorization
  extend ActiveSupport::Concern

  included do
    before_filter :require_authorization
  end

  private

  def require_authorization
    head 403 unless has_authorization?
  end

  def has_authorization?
    controllers_set.any? do |controllers|
      if controller = controllers[controller_name]
        controller["actions"].include?(action_name)
      end
    end
  end

  def controllers_set
    Restaurant::Config.roles.inject([]) do |result, (role, controllers)|
      result << controllers if doorkeeper_token.scopes.include?(role.to_sym)
      result
    end
  end
end
