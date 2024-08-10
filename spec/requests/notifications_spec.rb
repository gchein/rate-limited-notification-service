require 'rails_helper'

RSpec.describe "Notifications Controller", type: :request do
  let(:notification) { create(:notification) }
  let(:valid_params) { attributes_for(:notification, user_id: create(:user).id) }
  let(:invalid_params) { attributes_for(:notification, notification_type: nil, message: nil, user_id: nil) }

  describe 'POST /notifications -> #create' do
    context 'with valid parameters' do
      it "creates a new record" do
        expect {
          post notifications_path, params: { notification: valid_params }
        }.to change(Notification, :count).by(1)
      end

      it "returns http success" do
        post notifications_path, params: { notification: valid_params }
        expect(response).to have_http_status(:success)
      end

      it "responds with the created instance" do
        post notifications_path, params: { notification: valid_params }

        response_json = JSON.parse(response.body, { symbolize_names: true })
        created_record_params = response_json.filter { |key| valid_params.key?(key) }

        expect(created_record_params).to eq(valid_params)
      end
    end

    context 'with invalid parameters' do
      it "does not create a new record" do
        expect {
          post notifications_path, params: { notification: invalid_params }
        }.not_to change(Notification, :count)
      end

      it "returns http unprocessable entity" do
        post notifications_path, params: { notification: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "responds with the errors as a JSON" do
        post notifications_path, params: { notification: invalid_params }

        response_json = JSON.parse(response.body, { symbolize_names: true })

        expect(response_json.key?(:errors)).to be true
      end
    end
  end

end
