FactoryBot.define do
  factory :tax do
    rate 8
    began_at { Time.current }
  end
end
