# Define routes and a controller.
#
# Examples
#
#   # config/routes.rb
#   Restaurant::Router.route(self)
#
#     1. Define ResourcesController if not defined
#     2. Define these routes
#       GET    /:resources     -> reosurces#index
#       GET    /:resources/:id -> resources#show
#       POST   /:resources     -> resources#create
#       PUT    /:resources/:id -> resources#update
#       DELETE /:resources/:id -> resources#destroy
#
#
#   # config/routes.rb
#   namespace :v1 do
#     Restaurant::Router.route(self)
#   end
#
#     1. Define V1::ResourcesController if not defined
#     2. Define these routes
#       GET    /v1/:resources     -> v1/reosurces#index
#       GET    /v1/:resources/:id -> v1/resources#show
#       POST   /v1/:resources     -> v1/resources#create
#       PUT    /v1/:resources/:id -> v1/resources#update
#       DELETE /v1/:resources/:id -> v1/resources#destroy
#
module Restaurant
  class Router
    def self.route(*args)
      new(*args).route
    end

    attr_reader :router

    def initialize(router)
      @router = router
    end

    def route
      define_route
      define_controller
    end

    private

    def define_route
      router.instance_eval do
        scope ":resource" do
          controller :resources do
            get "" => :index
            get ":id" => :show
            post "" => :create
            put ":id" => :update
            delete ":id" => :destroy
          end
        end
      end
    end

    def define_controller
      namespace.const_get(:ResourcesController)
    rescue NameError
      namespace.const_set(:ResourcesController, controller_class)
    end

    def scope
      router.instance_variable_get(:@scope)
    end

    def controller_class
      Class.new(::ApplicationController) do
        include Restaurant::Actions
        respond_to :json
      end
    end

    def namespace
      scope[:module].to_s.camelize.constantize
    rescue NameError => exception
      if exception.to_s =~ /uninitialized constant (?:(.+)(?:::))?(.+)/
        $1.to_s.constantize.const_set($2, Module.new)
        retry
      end
    end
  end
end
