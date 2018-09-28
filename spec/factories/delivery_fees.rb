FactoryBot.define do
  factory :delivery_fee do
    fee 600
    per 5
    began_at { Time.current }
  end
end
