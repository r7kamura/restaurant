module Restaurant::Config
  class << self
    def roles
      @roles ||= YAML.load_file(path)
    end

    def controllers
      roles.inject([]) do |result, (role, controllers)|
        result += controllers.keys
      end.uniq
    end

    def path
      Rails.root.join("config/restaurant.yml").tap do |path|
        raise NoRolesError, "#{path} is not found" unless path.exist?
      end
    end
  end

  NoRolesError = Class.new(StandardError)
end
