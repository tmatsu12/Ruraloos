FactoryBot.define do
  factory :post do
    title { Faker::Lorem.characters(number: 5) }
    body { Faker::Lorem.characters(number: 20) }
    body1 { Faker::Lorem.characters(number: 20) }
    body2 { Faker::Lorem.characters(number: 20) }
    body3 { Faker::Lorem.characters(number: 20) }
    city { Faker::Address.city }
    # prefecture_id { Faker::Number.within(range: 35..38) }
    # prefecture_id { 36 }
    evaluation { Faker::Number.within(range: 1..5) }
    association :user
    association :prefecture
  end
end
