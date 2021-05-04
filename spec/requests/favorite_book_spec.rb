require 'rails_helper'

RSpec.describe "FavoriteBooks", type: :request do
  let!(:login_user) { create(:user) }
  let(:auth_params) { sign_in(login_user) }

  let(:valid_headers) {
    {}.merge(auth_params)
  }

  let(:invalid_params) {
    { book_id: nil }
  }

  let(:response_data) { JSON.parse(response.body) }

  describe "GET /favorite_books" do
    subject { get favorite_books_path, headers: valid_headers, as: :json }

    context 'not has data' do
      before do
        subject
      end

      it "status:200" do
        expect(response.status).to eq(200)
      end

      it "response size:0" do
        expect(response_data["favorite_books"].length).to eq(0)
      end
    end

    context 'has data' do
      let!(:book) { create(:book) }
      let!(:book2) { create(:book) }
      let!(:book3) { create(:book) }
      let!(:favorite_book) { create(:favorite_book, user: login_user, book: book) }
      let!(:favorite_book2) { create(:favorite_book, user: login_user, book: book2) }
      let!(:favorite_book3) { create(:favorite_book, user: create(:user), book: book3) }

      before do
        subject
      end

      it "status:200" do
        expect(response.status).to eq(200)
      end
      it "response size:2" do
        expect(response_data["favorite_books"].length).to eq(2)
      end

      it "response data is correct" do
        expect(response_data["favorite_books"]).to match_array([
          book.id,
          book2.id,
        ])
      end
    end
  end

  describe "POST /favorite_books" do
    subject { post favorite_books_path,
               params: params, headers: valid_headers, as: :json }

    let!(:book) { create(:book) }

    before do
      notice_mailer_mock = double('NoticeMailer mock')
      allow(notice_mailer_mock).to receive(:deliver)
      allow(NoticeMailer).to receive(:send_favorited_your_book).and_return(notice_mailer_mock)
    end

    context "with valid parameters" do
      let(:params) { { 
        book_id: book.id
      } }

      it "new FavoriteBook is created" do
        expect {
          subject
        }.to change(FavoriteBook, :count).by(1)
      end

      it "send_favorited_your_book is called" do
        subject
        expect(NoticeMailer).to have_received(:send_favorited_your_book).with(book.user, book)
      end

      it "status:201" do
        subject
        expect(response.status).to eq(201)
      end

      it "response data is correct" do
        subject
        expect(response_data["id"]).to eq(FavoriteBook.last.id)
        expect(response_data["book_id"]).to eq(book.id)
      end
    end

    context "with invalid parameters" do
      let(:params) { { book_id: nil } }

      it "does not create a new Book" do
        expect {
          subject
        }.to change(FavoriteBook, :count).by(0)
      end

      it "status:422" do
        subject
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE /favorite_books/:book_id" do
    subject { delete favorite_book_path(book),
              headers: valid_headers, as: :json }

    let!(:book) { create(:book) }

    context 'has data' do
      let!(:favorite_book) { create(:favorite_book, user: login_user, book: book) }

      it "FavoriteBook is destroyed" do
        expect {
          subject
        }.to change(FavoriteBook, :count).by(-1)
      end

      it "status:204" do
        subject
        expect(response.status).to eq(204)
      end
    end

    context 'not has data' do
      let!(:favorite_book) { create(:favorite_book, user: create(:user), book: book) }

      it "status:404" do
        subject
        expect(response.status).to eq(404)
      end
    end
  end
end
