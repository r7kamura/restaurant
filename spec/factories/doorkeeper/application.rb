FactoryGirl.define do
  factory :doorkeeper_application, :class => Doorkeeper::Application do
    sequence(:name) {|i| "name #{i}" }
    sequence(:redirect_uri) {|i| "http://example#{i}.com/callback" }
  end
end
