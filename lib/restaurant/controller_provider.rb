module Restaurant::ControllerProvider
  extend ActiveSupport::Concern

  included do
    Restaurant::Config.controllers.each do |controller|
      class_name = "#{controller.camelize.pluralize}Controller"
      unless Object.const_defined?(class_name)
        Object.const_set(class_name, Class.new(self))
      end
    end
  end
end
