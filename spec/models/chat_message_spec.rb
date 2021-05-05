require 'rails_helper'

RSpec.describe ChatMessage, type: :model do
  it 'valid' do
    expect(build(:chat_message)).to be_valid
  end
end
