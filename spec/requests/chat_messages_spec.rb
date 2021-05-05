require 'rails_helper'

RSpec.describe "ChatMessages", type: :request do
  let!(:login_user) { create(:user) }
  let(:auth_params) { sign_in(login_user) }

  let(:valid_headers) {
    {}.merge(auth_params)
  }

  let(:response_data) { JSON.parse(response.body) }

  describe "GET /index" do
    subject { get chat_messages_url, headers: valid_headers, as: :json }

    context 'not has data' do
      before do
        subject
      end

      it "status:200" do
        expect(response.status).to eq(200)
      end

      it "response size:0" do
        expect(response_data["chat_messages"].length).to eq(0)
      end
    end

    context 'has data' do
      let!(:chat_message) { create(:chat_message) }
      let!(:chat_message2) { create(:chat_message) }

      before do
        subject
      end

      it "status:200" do
        expect(response.status).to eq(200)
      end
      it "response size:2" do
        expect(response_data["chat_messages"].length).to eq(2)
      end

      it "response data is correct" do
        expect(response_data["chat_messages"]).to match_array([
          {
            "id" => chat_message.id,
            "content" => chat_message.content,
          },
          {
            "id" => chat_message2.id,
            "content" => chat_message2.content,
          },
        ])
      end
    end
  end
end
