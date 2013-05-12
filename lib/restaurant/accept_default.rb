module Restaurant::AcceptDefault
  extend ActiveSupport::Concern

  included do
    use Rack::AcceptDefault
  end
end
