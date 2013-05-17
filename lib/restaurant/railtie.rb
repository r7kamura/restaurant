module Restaurant
  class Railtie < Rails::Railtie
    config.after_initialize do
      Rails.application.reload_routes!
      unless Restaurant::Router.called?
        Rails.application.routes.append do
          Restaurant::Router.route(self)
        end
      end
    end
  end
end
