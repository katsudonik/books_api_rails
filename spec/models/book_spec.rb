require 'rails_helper'

RSpec.describe Book, type: :model do
  it 'valid' do
    expect(build(:book)).to be_valid
  end
  describe 'validation' do
    describe 'title' do
      context 'title:nil' do
        it 'invalid' do
          expect(build(:book, title: nil)).not_to be_valid
        end
      end
      context 'title:101 characters' do
        it 'invalid' do
          expect(build(:book, title: 'a' * 101)).not_to be_valid
        end
      end
      context 'title:100 characters' do
        it 'valid' do
          expect(build(:book, title: 'a' * 100)).to be_valid
        end
      end
    end
    describe 'body' do
      context 'body:nil' do
        it 'invalid' do
          expect(build(:book, body: nil)).not_to be_valid
        end
      end
      context 'body:256 characters' do
        it 'invalid' do
          expect(build(:book, body: 'a' * 256)).not_to be_valid
        end
      end
      context 'body:255 characters' do
        it 'valid' do
          expect(build(:book, body: 'a' * 255)).to be_valid
        end
      end
    end
  end
  describe 'methods' do
    let!(:book) { create(:book) }

    describe '#update_favorite_num' do
      context 'favorite by 2 user' do
        before do
          create(:favorite_book, user: create(:user), book: book)
          create(:favorite_book, user: create(:user), book: book)
        end

        it 'favorite_num:2' do
          expect(book.favorite_num).to eq(2)
        end
      end      
      context 'favorite by 0 user' do
        it 'favorite_num:0' do
          expect(book.favorite_num).to eq(0)
        end
      end      
    end
  end
end
