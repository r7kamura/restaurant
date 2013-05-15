class Restaurant::Router
  def self.route(*args)
    new(*args).route
  end

  attr_reader :router

  def initialize(router)
    @router = router
  end

  def route
    Restaurant::Config.versions.each do |version, scopes|
      router.namespace(version) do
        scopes.each do |scope, controllers|
          controllers.each do |controller, values|
            router.resources controller, :only => values["actions"]
          end
        end
      end
    end
  end
end
