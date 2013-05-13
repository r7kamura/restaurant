module Restaurant::ControllerHelper
  extend ActiveSupport::Concern

  included do
    include Restaurant::AcceptDefault
    include Restaurant::ControllerProvider
    include Restaurant::ModelClassFinder
    include Restaurant::RestfulActions
    self.responder = Restaurant::ParamsQueryResponder
  end
end
