module Restaurant::RestfulActions
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do
      head 404
    end

    hide_action :current_version
  end

  def index
    respond_with model.scoped, :only => current_role.allowed_attributes
  end

  def show
    respond_with resource, :only => current_role.allowed_attributes
  end

  def create
    respond_with model.create(resource_param), :only => current_role.allowed_attributes
  end

  def update
    respond_with resource.update_attributes(resource_param)
  end

  def destroy
    respond_with resource.delete
  end

  def current_version
    @current_version ||= self.class.name.split("::").first.underscore
  end

  private

  def model
    model_name.constantize
  rescue NameError
    define_model
  end

  def model_name
    self.class.name.sub(/Controller$/, "").singularize
  end

  def resource_param
    params[resource_class_name.underscore]
  end

  def resource
    model.find(params[:id])
  end

  def resource_class_name
    model_name.split("::").last
  end

  def define_model
    current_version_module.const_set(resource_class_name, Class.new(ActiveRecord::Base))
  end

  def current_version_module
    current_version.camelize.constantize
  end
end
