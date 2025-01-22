# spec for UserMood Model test including:
# - Validations
# - customized scope queries.

require 'rails_helper'

RSpec.describe UserMood, type: :model do

  # validation test for fields.
  describe 'validations' do
    it 'is valid with valid attributes' do
      user_mood = UserMood.new(username: 'ethan wang', mood: 1, comment: 'A new day.')
      expect(user_mood).to be_valid
    end

    it 'is invalid without a username' do
      user_mood = UserMood.new(mood: 1)
      expect(user_mood).to_not be_valid
    end

    it 'is invalid without a mood' do
      user_mood = UserMood.new(username: 'ethan wang')
      expect(user_mood).to_not be_valid
    end

    it 'is valid without a comment' do
      user_mood = UserMood.new(username: 'ethan wang', mood: 1)
      expect(user_mood).to be_valid
    end

    it 'is invalid if the comment exceeds the maximum length' do
      long_comment = 'a' * 2047
      user_mood = UserMood.new(username: 'ethan wang', mood: 2, comment: long_comment)
      expect(user_mood).to_not be_valid
    end
  end

  describe 'scopes' do
    let!(:user_mood1) { UserMood.create(uuid: '46cc95a8-8497-4628-9dfe-12a20764487f', username: 'ethan wang', mood: 1,
                                        comment: '111', created_at: '2025-01-01') }
    let!(:user_mood2) { UserMood.create(uuid: '235d2cb4-0aea-45d6-8041-0399a6c1331e', username: 'ethan wang', mood: 2,
                                        comment: '222', created_at: '2025-01-02') }
    let!(:user_mood3) { UserMood.create(uuid: '23ef3880-71ee-471d-b988-2de9120a0b22', username: 'ethan liang', mood: 3,
                                        comment: '333', created_at: '2025-01-03') }

    describe '.find_by_username_and_mood' do
      it 'returns records for a given username' do
        result = UserMood.find_by_username_and_mood('ethan wang', nil)
        expect(result).to include(user_mood1, user_mood2)
      end

      it 'returns records for a given mood' do
        result = UserMood.find_by_username_and_mood(nil, 2)
        expect(result).to include(user_mood2)
      end

      it 'returns records for a given username and mood' do
        result = UserMood.find_by_username_and_mood('ethan wang', 2)
        expect(result).to include(user_mood2)
      end

      it 'returns records ordered by created_at desc' do
        result = UserMood.find_by_username_and_mood(nil, nil, page: 1, per_page: 10)
        expect(result.first).to eq(user_mood3) # Most recent first
        expect(result.second).to eq(user_mood2)
      end
    end

    describe '.find_by_username_and_date' do
      it 'returns a user mood for a specific date' do
        result = UserMood.find_by_username_and_date('ethan liang', '2025-01-03')
        expect(result).to include(user_mood3)
      end

      it 'returns empty if no user mood is found for the given date' do
        result = UserMood.find_by_username_and_date('ethan123', '2025-01-04')
        expect(result).to be_empty
      end
    end
  end
end
