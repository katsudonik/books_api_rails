FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    body { Faker::Food.description }
    user { build(:user) }

    after(:build) do  |book|
      build(:image, book: book)
    end
  end
end
