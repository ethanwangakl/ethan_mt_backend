# spec for AdminUser Model test including:
# - Validations
# - Check password verification logic

require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      admin_user = AdminUser.new(username: 'admin', password: 'password123')
      expect(admin_user).to be_valid
    end

    it 'is not valid without a username' do
      admin_user = AdminUser.new(username: nil, password: 'password123')
      expect(admin_user).to_not be_valid
    end

    it 'is not valid with a duplicate username' do
      AdminUser.create!(username: 'admin', password: 'password123')
      admin_user = AdminUser.new(username: 'admin', password: 'password456')
      expect(admin_user).to_not be_valid
    end

    it 'is not valid if the username is too long' do
      admin_user = AdminUser.new(username: 'a' * 101, password: 'password123')
      expect(admin_user).to_not be_valid
    end

    it 'is not valid without a password' do
      admin_user = AdminUser.new(username: 'admin', password: nil)
      expect(admin_user).to_not be_valid
    end

    it 'is not valid if the password is too long' do
      admin_user = AdminUser.new(username: 'admin', password: 'a' * 256)
      expect(admin_user).to_not be_valid
    end
  end

  describe 'has_secure_password' do
    it 'sets the password_digest correctly' do
      admin_user = AdminUser.create!(username: 'admin', password: 'password123')
      expect(admin_user.password_digest).to_not be_nil
    end

    it 'authenticates with correct password' do
      admin_user = AdminUser.create!(username: 'admin', password: 'password123')
      expect(admin_user.authenticate('password123')).to eq(admin_user)
    end

    it 'does not authenticate with incorrect password' do
      admin_user = AdminUser.create!(username: 'admin', password: 'password123')
      expect(admin_user.authenticate('wrongpassword')).to be_falsey
    end
  end
end
