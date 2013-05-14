module Restaurant::RestfulActions
  extend ActiveSupport::Concern

  def index
    respond_with model.scoped, :only => current_role.allowed_attributes
  end

  def show
    respond_with resource, :only => current_role.allowed_attributes
  end

  def create
    respond_with model.create(model_param), :only => current_role.allowed_attributes
  end

  def update
    respond_with resource.update_attributes(model_param), :only => current_role.allowed_attributes
  end

  private

  def model
    self.class.name.sub(/Controller$/, "").singularize.constantize
  end

  def model_param
    params[model.name.underscore]
  end

  def resource
    model.find(params[:id])
  end
end
