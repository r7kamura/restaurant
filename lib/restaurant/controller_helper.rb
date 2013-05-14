module Restaurant::ControllerHelper
  extend ActiveSupport::Concern

  included do
    use Rack::AcceptDefault
    include Restaurant::ControllerProvider
    include Restaurant::RestfulActions
    include Restaurant::Authentication
    include Restaurant::Authorization
    include Restaurant::RoleProvider
    self.responder = Restaurant::ParamsQueryResponder
    respond_to :json
  end
end
