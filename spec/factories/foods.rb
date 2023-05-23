FactoryBot.define do
  factory :food do
    name { Faker::Food.ingredient }
    measurement_unit { Faker::Food.metric_measurement }
    price { Faker::Commerce.price(range: 0..10.0) }
    quantity { Faker::Number.between(from: 1, to: 10) }
    association :user
  end
end
