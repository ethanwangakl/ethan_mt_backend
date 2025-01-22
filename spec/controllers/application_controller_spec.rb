require 'rails_helper'
require 'jwt'

RSpec.describe ApplicationController, type: :controller do
  # Mocking the JwtHelper and AdminUser for the tests
  let(:valid_token) { JwtHelper.encode(user_id: 1) } # Assuming user ID 1 is valid
  let(:invalid_token) { 'invalid.token' }

  # Test the global exception handler for StandardError
  describe 'StandardError Handling' do
    controller(ApplicationController) do
      def index
        raise StandardError, "Standard error occurred"
      end
    end

    it 'handles StandardError and returns 500 status' do
      get :index

      expect(response).to have_http_status(:internal_server_error)
      expect(JSON.parse(response.body)["message"]).to eq("Internal error")
    end
  end

  # Test is_admin_login method with valid or invalid token
  describe 'Test is_admin_login' do
    controller(ApplicationController) do
      def index
        render json: { is_admin: is_admin_login }
      end
    end

    it 'returns true if the admin user is logged in' do
      request.headers["Authorization"] = "Bearer #{valid_token}"
      allow(AdminUser).to receive(:exists?).with(id: 1).and_return(true) # Mocking the AdminUser.exists? method
      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["is_admin"]).to be_truthy
    end

    it 'returns false if the token is invalid' do
      request.headers["Authorization"] = "Bearer #{invalid_token}"
      get :index

      expect(response).to have_http_status(:internal_server_error)
      expect(JSON.parse(response.body)["is_admin"]).to be_falsey
    end

    it 'returns false if the user is not an admin' do
      request.headers["Authorization"] = "Bearer #{valid_token}"
      allow(AdminUser).to receive(:exists?).with(id: 1).and_return(false)
      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["is_admin"]).to be_falsey
    end
  end
end