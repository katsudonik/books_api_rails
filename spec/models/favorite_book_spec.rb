require 'rails_helper'

RSpec.describe FavoriteBook, type: :model do
  it 'valid' do
    expect(build(:favorite_book)).to be_valid
  end
end
