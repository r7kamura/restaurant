module Restaurant::RestfulActions
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do
      head 404
    end
  end

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
    respond_with resource.update_attributes(model_param)
  end

  def destroy
    respond_with resource.delete
  end

  private

  def model
    model_name.constantize
  rescue NameError
    define_model
  end

  def model_name
    @model_name ||= self.class.name.sub(/Controller$/, "").singularize
  end

  def model_param
    params[model_name.underscore]
  end

  def resource
    model.find(params[:id])
  end

  def define_model
    Object.const_set(model_name, Class.new(ActiveRecord::Base))
  end
end
