FactoryBot.define do
  factory :book do
    title { "MyString" }
    body { "MyText" }
    user { build(:user) }
  end
end
