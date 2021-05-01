FactoryBot.define do
  factory :image do
    picture_base64 { Base64.strict_encode64(File.open(::Rails.root.join('spec', 'fixtures', 'correct_1.png')).read) }
  end
end
