FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.safe_email }
    password { Faker::Internet.password }
    provider { 'email' }
    name { Faker::Name.name }
    nickname { Faker::FunnyName.name }

    after(:build) do  |user|
      build(:image, user: user)
    end
  end
end