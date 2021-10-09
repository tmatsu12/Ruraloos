FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    # prefecture1_id { Faker::Number.within(range: 35..38) }
    # prefecture1_id { 36 }
    # prefecture2_id { Faker::Number.within(range: 35..38) }
    # prefecture2_id { 36 }
    # association :prefecture, factory: :prefecture1
    # association :prefecture, factory: :prefecture2
  end
end
