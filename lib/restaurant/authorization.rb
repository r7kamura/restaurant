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
    has_action_authorization? && has_query_authorization?
  end

  def has_action_authorization?
    current_abilities.any? do |ability|
      ability["actions"].include?(action_name)
    end
  end

  def has_query_authorization?
    if has_not_allowed_where? || has_not_allowed_order?
      false
    else
      true
    end
  end

  def has_where_query?
    params[:where]
  end

  def has_order_query?
    params[:order]
  end

  def current_abilities
    @current_abilities ||= Restaurant::Config.roles.map do |role, controllers|
      if doorkeeper_token.scopes.include?(role.to_sym)
        controllers[controller_name]
      end
    end.compact
  end

  def current_order_abilities
    current_abilities.inject([]) do |columns, ability|
      columns + (ability["order"] || [])
    end
  end

  def current_where_abilities
    current_abilities.inject([]) do |columns, ability|
      columns + (ability["where"] || [])
    end
  end

  def has_not_allowed_where?
    has_where_query? && (where_queries - current_where_abilities).any?
  end

  def has_not_allowed_order?
    has_order_query? && (order_queries - current_order_abilities).any?
  end

  def where_queries
    params[:where].keys
  end

  def order_queries
    Array.wrap(params[:order]).map do |column|
      column.sub(/^-/, "")
    end
  end
end
