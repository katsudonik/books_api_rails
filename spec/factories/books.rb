FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    body { Faker::Food.description }
    user { build(:user) }
  end
end
