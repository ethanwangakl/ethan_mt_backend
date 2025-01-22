require 'rails_helper'

RSpec.describe UserMoodsController, type: :controller do

  let(:valid_username) { "test_user" }
  let(:valid_mood_key) { "pretty_good" }
  let(:invalid_mood_key) { "invalid mood key" }

  describe "POST #create" do
    it "creates a new user mood when username, mood key are both valid" do
      post :create, params: { username: valid_username,
                              mood_key: MoodEnum.mood_key_from_string(valid_mood_key),
                              comment: "good day" }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["username"]).to eq(valid_username)
      expect(JSON.parse(response.body)["mood"]).to eq(valid_mood_key)
      expect(JSON.parse(response.body)["comment"]).to eq("good day")
    end

    it "creates a duplicate user mood" do
      post :create, params: { username: valid_username,
                              mood_key: MoodEnum.mood_key_from_string(valid_mood_key),
                              comment: "good day" }

      expect(response).to have_http_status(:created)

      # Create again for today which should return error
      post :create, params: { username: valid_username,
                              mood_key: MoodEnum.mood_key_from_string(valid_mood_key),
                              comment: "good day" }

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["message"]).to eq("We have your mood today")
    end

    it "returns a bad request error when mood key is invalid" do
      post :create, params: { username: valid_username, mood_key: invalid_mood_key, comment: nil }

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["message"]).to eq("Invalid mood key")
    end

    it "returns an internal server error when saving fails" do
      allow(UserMood).to receive(:new).and_return(double(save: false, errors: double(full_messages: ["Database error"])))
      post :create, params: { username: valid_username, mood_key: valid_mood_key, comment: "good day" }

      expect(response).to have_http_status(:internal_server_error)
      expect(JSON.parse(response.body)["message"]).to eq("Failed to create user mood")
    end
  end

  describe "GET #index" do
    it "returns user moods for the specified username when user moods exist" do
      user_mood = double("UserMood", uuid: SecureRandom.uuid, username: valid_username, mood: 2,
                         comment: nil, created_at: Time.now, updated_at: Time.now)
      allow(UserMood).to receive(:find_by_username_and_mood).with(valid_username, nil).and_return([user_mood])

      get :index, params: { username: valid_username }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)[0]["username"]).to eq(valid_username)
      expect(JSON.parse(response.body)[0]["mood"]).to eq(valid_mood_key)
    end

    it "returns a not found error when no user moods exist" do
      allow(UserMood).to receive(:find_by_username_and_mood).with(valid_username, nil).and_return([])

      get :index, params: { username: valid_username }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["message"]).to eq("No user moods found for user #{valid_username}")
    end
  end

  describe "GET #admin_index" do
    it "returns an unauthorized error when the user is not an admin" do
      allow(controller).to receive(:is_admin_login).and_return(false)
      get :admin_index

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["message"]).to eq("Not admin log in")
    end

    context "when the user is an admin" do
      before { allow(controller).to receive(:is_admin_login).and_return(true) }

      it "returns a bad request error when mood key is invalid" do
        get :admin_index, params: { mood_key: invalid_mood_key }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["message"]).to eq("Invalid mood key")
      end

      it "returns all user moods when user moods exist" do
        user_mood = double("UserMood", uuid: SecureRandom.uuid, username: valid_username, mood: 2,
                           comment: nil, created_at: Time.now, updated_at: Time.now)
        allow(UserMood).to receive(:find_by_username_and_mood).with(valid_username, 2, page: nil, per_page: nil).and_return([user_mood])
        get :admin_index, params: { username: valid_username, mood_key: valid_mood_key }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)[0]["username"]).to eq(valid_username)
        expect(JSON.parse(response.body)[0]["mood"]).to eq(valid_mood_key)
      end

      it "returns a not found error when no user moods exist" do
        allow(UserMood).to receive(:find_by_username_and_mood).and_return([])
        get :admin_index

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["message"]).to eq("No user moods found")
      end
    end
  end
end
