FactoryBot.define do
  factory :favorite_book do
    book { build(:book) }
    user { build(:user) }
  end
end
