# Force to load ApplicationController to define the other controllers.
class Restaurant::Railtie < Rails::Railtie
  config.after_initialize do
    ::ApplicationController
  end
end
