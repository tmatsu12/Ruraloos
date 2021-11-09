FactoryBot.define do
  factory :user_prefecture do
    status { Faker::Number.within(range: 0..1) }
    user
    prefecture
  end
end