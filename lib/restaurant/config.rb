module Restaurant::Config
  class << self
    def versions
      @versions ||= YAML.load_file(path)
    end

    def path
      Rails.root.join("config/restaurant.yml").tap do |path|
        raise NoRolesError, "#{path} is not found" unless path.exist?
      end
    end

    def define_version_modules
      version_module_names.each do |version_module_name|
        unless Object.const_defined?(version_module_name)
          Object.const_set(version_module_name, Module.new)
        end
      end
    end

    def define_controller_classes(base)
      versions.each do |version, scopes|
        scopes.each do |scope, controllers|
          controllers.keys.each do |controller|
            version_module = version.camelize.constantize
            controller_class_name = "#{controller.camelize}Controller"
            unless version_module.const_defined?(controller_class_name)
              version_module.const_set(controller_class_name, Class.new(base))
            end
          end
        end
      end
    end

    def version_module_names
      versions.keys.map do |version_name|
        version_name.camelize
      end
    end
  end

  NoRolesError = Class.new(StandardError)
end
