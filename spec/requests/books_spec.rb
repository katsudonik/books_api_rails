require 'rails_helper'

RSpec.describe "/books", type: :request do
  let!(:login_user) { create(:user) }
  let(:auth_params) { sign_in(login_user) }

  let(:valid_headers) {
    {}.merge(auth_params)
  }

  let(:valid_params) {
    { 
      title: "title_example", 
      body: "body_example", 
      image_attributes: {
        picture_base64: Base64.strict_encode64(File.open(::Rails.root.join('spec', 'fixtures', 'correct_1.png')).read)
      }
    }
  }

  let(:invalid_params) {
    { title: "", body: "body_example" }
  }

  let(:response_data) { JSON.parse(response.body) }

  describe "GET /books" do
    subject { get books_url, headers: valid_headers, as: :json }

    context 'not has data' do
      before do
        subject
      end

      it "status:200" do
        expect(response.status).to eq(200)
      end

      it "response size:0" do
        expect(response_data["books"].length).to eq(0)
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
        expect(response_data["books"].length).to eq(2)
      end

      it "response data is correct" do
        expect(response_data["books"]).to match_array([
          {
            "id" => book.id,
            "title" => book.title,
            "body" => book.body,
            "image" => {
              "picture_url" => anything
            }
          },
          {
            "id" => book2.id,
            "title" => book2.title,
            "body" => book2.body,
            "image" => {
              "picture_url" => anything
            }
          },
        ])
      end
    end
  end

  describe "GET /books/:id" do
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
          expect(response_data["image"]["picture_url"]).not_to eq(nil)
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
          expect(response_data["image"]["picture_url"]).not_to eq(nil)
        end
      end
    end
  end

  describe "POST /books" do
    subject { post books_url,
               params: params, headers: valid_headers, as: :json }

    context "with valid parameters" do
      let(:params) { valid_params }

      it "new Book is created" do
        expect {
          subject
        }.to change(Book, :count).by(1)
      end

      it "new Image is created" do
        expect {
          subject
        }.to change(Image, :count).by(1)
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
        expect(response_data["image"]["picture_url"]).not_to eq(nil)
      end
    end

    context "not has image parameters" do
      let(:params) {
        { 
        title: "title_example", 
        body: "body_example"
      } }

      it "new Book is created" do
        expect {
          subject
        }.to change(Book, :count).by(1)
      end

      it "new Image is not created" do
        expect {
          subject
        }.not_to change(Image, :count)
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
        expect(response_data["image"]).to eq(nil)
      end
    end


    context "with invalid parameters" do
      let(:params) { invalid_params }

      it "does not create a new Book" do
        expect {
          subject
        }.to change(Book, :count).by(0)
      end

      it "does not create a new Image" do
        expect {
          subject
        }.to change(Image, :count).by(0)
      end

      it "status:422" do
        subject
        expect(response.status).to eq(422)
      end
    end
  end

  describe "PATCH /books/:id" do
    subject { patch book_url(book),
              params: params, headers: valid_headers, as: :json }

    let(:params) { valid_params }

    context 'has data' do
      let!(:book) { create(:book, user: login_user) }

      context "with valid parameters" do
        it "status:200" do
          subject
          expect(response.status).to eq(200)
        end

        it "response data is correct" do
          subject
          expect(response_data["id"]).to eq(book.id)
          expect(response_data["title"]).to eq(valid_params[:title])
          expect(response_data["body"]).to eq(valid_params[:body])
          expect(response_data["image"]["picture_url"]).not_to eq(nil)
        end
      end

      context "with invalid parameters" do
        let(:params) { invalid_params }

        it "status:422" do
          subject
          expect(response.status).to eq(422)
        end
      end

      context 'destroy_image:true' do
        let(:params) {
          { 
            destroy_image: true
          }
        }

        it "Image is destroyed" do
          expect {
            subject
          }.to change(Image, :count).by(-1)
        end

        it "Book is unchanged" do
          expect {
            subject
          }.not_to change(Book, :count)
        end

        it "status:200" do
          subject
          expect(response.status).to eq(200)
        end

        it "response data is correct" do
          subject
          expect(response_data["id"]).to eq(book.id)
          expect(response_data["title"]).to eq(book.title)
          expect(response_data["body"]).to eq(book.body)
          expect(response_data["image"]).to eq(nil)
        end

        context "with invalid parameters" do
          let(:params) { { 
            destroy_image: true
          }.merge(invalid_params) }

          it "Image is not destroyed" do
            expect {
              subject
            }.not_to change(Image, :count)
          end
        end
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

  describe "DELETE /books/:id" do
    subject { delete book_url(book),
              headers: valid_headers, as: :json }

    context 'has data' do
      let!(:book) { create(:book, user: login_user) }

      it "Book is destroyed" do
        expect {
          subject
        }.to change(Book, :count).by(-1)
      end
      it "Image is destroyed" do
        expect {
          subject
        }.to change(Image, :count).by(-1)
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
