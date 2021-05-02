require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:login_user) { create(:user) }
  let(:auth_params) { sign_in(login_user) }

  let(:valid_headers) {
    {}.merge(auth_params)
  }

  let(:valid_params) {
    { 
      name: "name_example", 
      nickname: "nickname_example", 
      image_attributes: {
        picture_base64: Base64.strict_encode64(File.open(::Rails.root.join('spec', 'fixtures', 'correct_1.png')).read)
      }
    }
  }

  let(:response_data) { JSON.parse(response.body) }

  describe "GET /users/:id" do
    let!(:user) { login_user }

    subject { get user_url(user), headers: valid_headers, as: :json }

    before do
      subject
    end

    context 'not has data' do
      let!(:user) { 1 }

      it "status:404" do
        expect(response.status).to eq(404)
      end
    end

    context 'has data' do
      it "status:200" do
        expect(response.status).to eq(200)
      end
      it "response data is correct" do
        expect(response_data["id"]).to eq(user.id)
        expect(response_data["name"]).to eq(user.name)
        expect(response_data["nickname"]).to eq(user.nickname)
        expect(response_data["image"]["picture_url"]).not_to eq(nil)
      end
    end
  end

  describe "PATCH /users/:id" do
    let!(:user) { login_user }

    subject { patch user_url(user),
              params: params, headers: valid_headers, as: :json }

    let(:params) { valid_params }

    context 'has data' do
      context "with valid parameters" do
        it "status:200" do
          subject
          expect(response.status).to eq(200)
        end

        it "response data is correct" do
          subject
          expect(response_data["id"]).to eq(user.id)
          expect(response_data["name"]).to eq(valid_params[:name])
          expect(response_data["nickname"]).to eq(valid_params[:nickname])
          expect(response_data["image"]["picture_url"]).not_to eq(nil)
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

        it "user is unchanged" do
          expect {
            subject
          }.not_to change(User, :count)
        end

        it "status:200" do
          subject
          expect(response.status).to eq(200)
        end

        it "response data is correct" do
          subject
          expect(response_data["id"]).to eq(user.id)
          expect(response_data["name"]).to eq(user.name)
          expect(response_data["nickname"]).to eq(user.nickname)
          expect(response_data["image"]).to eq(nil)
        end
      end      
    end
  end
end
