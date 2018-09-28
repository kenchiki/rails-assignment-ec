FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    password 'testtest'
    confirmed_at Time.current
    trait :with_shipping_address do
      after(:build) do |user|
        user.shipping_addresses << FactoryBot.build(:shipping_address)
      end
    end
  end
end
