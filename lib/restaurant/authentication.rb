module Restaurant::Authentication
  extend ActiveSupport::Concern

  included do
    doorkeeper_for :all
  end
end
