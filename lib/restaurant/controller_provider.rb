module Restaurant::ControllerProvider
  extend ActiveSupport::Concern

  included do
    Restaurant::Config.define_version_modules
    Restaurant::Config.define_controller_classes(self)
  end
end
