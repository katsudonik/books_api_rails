FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.safe_email }
    password { Faker::Internet.password }
    provider { 'email' }
  end
end