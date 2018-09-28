FactoryBot.define do
  factory :cart_product, class: CartProduct do
    quantity 1
    product { FactoryBot.create(:product) }
    cart { FactoryBot.create(:cart) }
  end
end
