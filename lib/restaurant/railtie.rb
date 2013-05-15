class Restaurant::Railtie < Rails::Railtie
  config.after_initialize do
    Rails.application.routes.append { Restaurant::Router.route(self) }
    ApplicationController.send :include, Restaurant::ControllerHelper
  end
end
