class Restaurant::ParamsQueryResponder < ActionController::Responder
  def initialize(controller, resources, options = {})
    if resources.last.is_a? ActiveRecord::Relation
      resources[-1] = Restaurant::ParamsQueryTranslator.translate(controller.params, resources.last)
    end
    super(controller, resources, options)
  end
end
