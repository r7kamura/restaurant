module Restaurant::RestfulActions
  extend ActiveSupport::Concern

  def index
    respond_with model_class.scoped, :only => current_role.allowed_attributes
  end

  def show
    respond_with model_class.find(params[:id]), :only => current_role.allowed_attributes
  end

  private

  def model_class
    self.class.name.sub(/Controller$/, "").singularize.constantize
  end
end
