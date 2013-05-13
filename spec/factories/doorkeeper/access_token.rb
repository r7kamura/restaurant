FactoryGirl.define do
  factory :doorkeeper_access_token, :class => Doorkeeper::AccessToken do
    application { FactoryGirl.create(:doorkeeper_application) }
    resource_owner_id { FactoryGirl.create(:user).id }
    scopes { "public" }
  end
end
