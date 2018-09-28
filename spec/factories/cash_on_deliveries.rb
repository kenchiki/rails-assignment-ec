FactoryBot.define do
  factory :cash_on_delivery, class: CashOnDelivery do
    began_at {Time.current}
    cash_on_delivery_fees_attributes [{ began_price: 0, fee: 300 },
                                      { began_price: 10_000, fee: 400 },
                                      { began_price: 30_000, fee: 600 },
                                      { began_price: 100_000, fee: 1000 }]
  end
end
