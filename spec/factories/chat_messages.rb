FactoryBot.define do
  factory :chat_message do
    content { Faker::Food.description }
  end
end
