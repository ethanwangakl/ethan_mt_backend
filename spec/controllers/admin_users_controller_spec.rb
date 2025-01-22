require 'rails_helper'

RSpec.describe AdminUsersController, type: :controller do
  describe "POST #login" do
    let(:admin_user) { double("AdminUser", id: 1, username: "admin") }
    let(:valid_credentials) { { username: "admin", password: "password" } }
    let(:invalid_credentials) { { username: "admin", password: "wrong_password" } }

    it "returns a JWT token and the username when admin user exists and password is correct" do
      allow(AdminUser).to receive(:find_by).with(username: "admin").and_return(admin_user)
      allow(admin_user).to receive(:authenticate).with("password").and_return(true)
      post :login, params: valid_credentials

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body).to include("token")
      expect(response_body["username"]).to eq(admin_user.username)
    end

    it "returns a 404 not found error when admin user does not exist" do
      allow(AdminUser).to receive(:find_by).with(username: "admin").and_return(nil)
      post :login, params: valid_credentials

      expect(response).to have_http_status(:not_found)
      response_body = JSON.parse(response.body)
      expect(response_body["message"]).to eq("Authenticate failed")
      expect(response_body["success"]).to eq(false)
    end

    it "returns an internal server error when password is incorrect" do
      allow(AdminUser).to receive(:find_by).with(username: "admin").and_return(admin_user)
      allow(admin_user).to receive(:authenticate).with("wrong_password").and_return(false)
      post :login, params: invalid_credentials

      expect(response).to have_http_status(:internal_server_error)
      response_body = JSON.parse(response.body)
      expect(response_body["message"]).to eq("Authenticate failed")
      expect(response_body["success"]).to eq(false)
    end
  end
end
