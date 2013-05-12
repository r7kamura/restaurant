module Restaurant::RestfulActions
  extend ActiveSupport::Concern

  included do
    include Restaurant::ModelClassFinder
  end

  def index
    respond_with model_class.all
  end

  def show
    respond_with model_class.find(params[:id])
  end
end
