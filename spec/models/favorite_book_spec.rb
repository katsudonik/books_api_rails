require 'rails_helper'

RSpec.describe FavoriteBook, type: :model do
  it 'valid' do
    expect(build(:favorite_book)).to be_valid
  end
  describe 'validation' do
    describe 'book_id' do
      let!(:favorite_book) { create(:favorite_book) }

      context 'destroyed data is not exist' do
        context 'build date duplicated to destroyed data' do
          it 'invalid' do
            expect(build(:favorite_book, book: favorite_book.book, user:favorite_book.user)).not_to be_valid
          end
        end
      end
      context 'destroyed data is exist' do
        before do
          favorite_book.destroy
        end

        context 'build date duplicated to destroyed data' do
          it 'valid' do
            expect(build(:favorite_book, book: favorite_book.book, user:favorite_book.user)).to be_valid
          end
        end
        context 'destroy data duplicated to destroyed data' do
          it 'invalid' do
            expect{ create(:favorite_book, book: favorite_book.book, user:favorite_book.user).destroy! }.not_to raise_error
          end
        end
      end
    end
  end
end
