FactoryBot.define do
  factory :product, class: Product do
    sequence(:name) { |n| "Product#{n}" }
    product_prices_attributes [{ price: 500 }]
    product_publishes_attributes [{ published: true }]

    trait :unpublished do
      product_publishes_attributes [{ published: false }]
    end

    trait :published do
      product_publishes_attributes [{ published: true }]
    end
  end
end
