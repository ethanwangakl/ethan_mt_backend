class AdminUser < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :password_digest, presence: true, length: { maximum: 255 }
end
