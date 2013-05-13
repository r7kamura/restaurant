module Restaurant::ControllerHelper
  extend ActiveSupport::Concern

  included do
    use Rack::AcceptDefault
    include Restaurant::ControllerProvider
    include Restaurant::ModelClassFinder
    include Restaurant::RestfulActions
    self.responder = Restaurant::ParamsQueryResponder
    doorkeeper_for :all
  end
end
