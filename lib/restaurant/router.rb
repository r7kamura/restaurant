class Restaurant::Router
  def self.route(*args)
    new(*args).route
  end

  attr_reader :router

  def initialize(router)
    @router = router
  end

  def route
    Restaurant::Config.roles.each do |role, controllers|
      controllers.each do |controller_name, definitions|
        router.resources controller_name, :only => definitions["actions"]
      end
    end
  end
end
