FactoryBot.define do
  factory :prefecture do
    id { Faker::Number.within(range: 0..46) }
    name { "北海道" }
  end
end
