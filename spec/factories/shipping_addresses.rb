FactoryBot.define do
  factory :shipping_address do
    name 'name'
    sequence(:address) { |n| "address#{n}" }
    post '111-1111'
    tel '111-1111-1111'
    user { FactoryBot.create(:user) }
  end
end
