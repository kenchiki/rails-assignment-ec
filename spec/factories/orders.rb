FactoryBot.define do
  factory :order do
    delivery_time { FactoryBot.create(:delivery_time) }
    delivery_date { DeliveryDateSchedule.new.schedule_dates.first }
    user { FactoryBot.create(:user) }
    cart { FactoryBot.create(:cart) }
    trait :with_shipping_address do
      user { FactoryBot.create(:user, :with_shipping_address) }
    end
  end
end
