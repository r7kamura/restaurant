module Restaurant::RoleProvider
  private

  def current_role
    @current_role ||= Role.new(self)
  end

  class Role
    delegate(
      :action_name,
      :controller_name,
      :doorkeeper_token,
      :params,
      :to => :controller
    )

    attr_reader :controller

    def initialize(controller)
      @controller = controller
    end

    def has_authorization?
      has_action_authorization? && has_query_authorization?
    end

    def abilities
      @abilities ||= Restaurant::Config.versions[controller.current_version].map do |role, controllers|
        if doorkeeper_token.scopes.include?(role.to_sym)
          controllers[controller_name]
        end
      end.compact
    end

    def allowed_attributes
      abilities.map {|ability| ability["attributes"] }.compact.inject(:|)
    end

    private

    def has_action_authorization?
      abilities.any? do |ability|
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

    def order_abilities
      abilities.inject([]) do |columns, ability|
        columns + (ability["order"] || [])
      end
    end

    def where_abilities
      abilities.inject([]) do |columns, ability|
        columns + (ability["where"] || [])
      end
    end

    def has_not_allowed_where?
      has_where_query? && (where_queries - where_abilities).any?
    end

    def has_not_allowed_order?
      has_order_query? && (order_queries - order_abilities).any?
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
end
