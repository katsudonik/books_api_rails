require 'rails_helper'

RSpec.describe "/books", type: :request do
  let(:login_user) { create(:user) }
  let(:auth_params) { sign_in(login_user) }

  let(:valid_headers) {
    {}.merge(auth_params)
  }

  let(:valid_params) {
    { title: "title_example", body: "body_example" }
  }

  let(:invalid_params) {
    { title: "", body: "body_example" }
  }

  let(:response_data) { JSON.parse(response.body) }

  describe "GET /index" do
    subject { get books_url, headers: valid_headers, as: :json }

    context 'not has data' do
      before do
        subject
      end

      it "status:200" do
        expect(response.status).to eq(200)
      end

      it "response size:0" do
        expect(response_data.length).to eq(0)
      end
    end

    context 'has data' do
      let!(:book) { create(:book, user: login_user) }
      let!(:book2) { create(:book) }

      before do
        subject
      end

      it "status:200" do
        expect(response.status).to eq(200)
      end
      it "response size:2" do
        expect(response_data.length).to eq(2)
      end

      it "response data is correct" do
        expect(response_data).to match_array({"books" => [
          {
            "id" => book.id,
            "title" => book.title,
            "body" => book.body
          },
          {
            "id" => book2.id,
            "title" => book2.title,
            "body" => book2.body
          },
        ]})
      end
    end
  end

  describe "GET /show" do
    subject { get book_url(book), headers: valid_headers, as: :json }

    before do
      subject
    end

    context 'not has data' do
      let!(:book) { 1 }

      it "status:404" do
        expect(response.status).to eq(404)
      end
    end

    context 'has data' do
      context 'login_user has this data' do
        let!(:book) { create(:book, user: login_user) }

        it "status:200" do
          expect(response.status).to eq(200)
        end
        it "response data is correct" do
          expect(response_data["id"]).to eq(book.id)
          expect(response_data["title"]).to eq(book.title)
          expect(response_data["body"]).to eq(book.body)
        end
      end
      context 'login_user not has this data' do
        let!(:book) { create(:book) }

        it "status:200" do
          expect(response.status).to eq(200)
        end
        it "response data is correct" do
          expect(response_data["id"]).to eq(book.id)
          expect(response_data["title"]).to eq(book.title)
          expect(response_data["body"]).to eq(book.body)
        end
      end
    end
  end

  describe "POST /create" do
    subject { post books_url,
               params: params, headers: valid_headers, as: :json }

    context "with valid parameters" do
      let(:params) { valid_params }

      it "new Book is created" do
        expect {
          subject
        }.to change(Book, :count).by(1)
      end

      it "status:201" do
        subject
        expect(response.status).to eq(201)
      end

      it "response data is correct" do
        subject
        expect(response_data["id"]).to eq(Book.last.id)
        expect(response_data["title"]).to eq(valid_params[:title])
        expect(response_data["body"]).to eq(valid_params[:body])
      end
    end

    context "with invalid parameters" do
      let(:params) { invalid_params }

      it "does not create a new Book" do
        expect {
          subject
        }.to change(Book, :count).by(0)
      end

      it "status:422" do
        subject
        expect(response.status).to eq(422)
      end
    end
  end

  describe "PATCH /update" do
    subject { patch book_url(book),
              params: params, headers: valid_headers, as: :json }

    let(:params) { valid_params }

    before do
      subject
    end

    context 'has data' do
      let!(:book) { create(:book, user: login_user) }

      context "with valid parameters" do
        it "status:200" do
          expect(response.status).to eq(200)
        end

        it "response data is correct" do
          expect(response_data["id"]).to eq(book.id)
          expect(response_data["title"]).to eq(valid_params[:title])
          expect(response_data["body"]).to eq(valid_params[:body])
        end
      end

      context "with invalid parameters" do
        let(:params) { invalid_params }

        it "status:422" do
          expect(response.status).to eq(422)
        end
      end
    end

    context 'not has data' do
      let!(:book) { create(:book) }

      it "status:404" do
        expect(response.status).to eq(404)
      end
    end
  end

  describe "DELETE /destroy" do
    subject { delete book_url(book),
              headers: valid_headers, as: :json }

    context 'has data' do
      let!(:book) { create(:book, user: login_user) }

      it "Book is destroyed" do
        expect {
          subject
        }.to change(Book, :count).by(-1)
      end
    end

    context 'not has data' do
      let!(:book) { create(:book) }

      it "status:404" do
        subject
        expect(response.status).to eq(404)
      end
    end
  end
end
