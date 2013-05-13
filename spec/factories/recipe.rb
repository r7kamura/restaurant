FactoryGirl.define do
  factory :recipe do
    sequence(:title) {|i| "title #{i}" }
    user { FactoryGirl.create(:user) }
  end
end
