module Restaurant::ControllerHelper
  extend ActiveSupport::Concern

  included do
    use Rack::AcceptDefault
    include Restaurant::ControllerProvider
    include Restaurant::ModelClassFinder
    include Restaurant::RestfulActions
    include Restaurant::Authentication
    include Restaurant::Authorization
    self.responder = Restaurant::ParamsQueryResponder
  end
end
