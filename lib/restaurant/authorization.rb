module Restaurant::Authorization
  extend ActiveSupport::Concern

  included do
    before_filter :require_authorization
  end

  private

  def require_authorization
    head 403 unless current_role.has_authorization?
  end
end
