FactoryGirl.define do
  factory :user do
    sequence(:name) {|i| "name #{i}" }
  end
end
