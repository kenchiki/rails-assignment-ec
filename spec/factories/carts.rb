FactoryBot.define do
  factory :cart, class: Cart do
    trait :with_cart_product do
      after(:build) do |cart|
        cart.cart_products << FactoryBot.build(:cart_product)
      end
    end
  end
end
