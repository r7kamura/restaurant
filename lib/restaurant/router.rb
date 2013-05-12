class Restaurant::Router
  def self.route(*args)
    new(*args).route
  end

  attr_reader :router

  def initialize(router)
    validate
    @router = router
  end

  def route
    roles.each do |role, controllers|
      controllers.each do |controller_name, definitions|
        router.resources controller_name, :only => definitions["actions"]
      end
    end
  end

  private

  def roles
    {
      "public" => YAML.load_file(roles_yaml_path),
    }
  end

  def roles_yaml_path
    Rails.root.join("config/roles.yml")
  end

  def validate
    unless roles_yaml_path.exist?
      raise NoRolesError, "config/roles.yml is not found"
    end
  end

  NoRolesError = Class.new(StandardError)
end
