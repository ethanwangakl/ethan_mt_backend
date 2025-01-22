class UserMood < ApplicationRecord
  validates :username, presence: true, length: { maximum: 64 }
  validates :mood, presence: true
  validates :comment, length: { maximum: 2046 }, allow_nil: true

  # Find user moods by either username or mood, or both with pagination
  scope :find_by_username_and_mood, ->(username, mood, page: 1, per_page: 100) {
    result = if username.present? && mood.present?
      where(username: username).where(mood: mood)
    elsif username.present?
      where(username: username)
    elsif mood.present?
      where(mood: mood)
    else
      all
    end

    result.order(created_at: :desc).page(page).per(per_page)
  }

  # check if the user has finished creating mood
  scope :find_by_username_and_date, ->(username, utc_date) {
    where("username = ? AND DATE(created_at) = ?", username, utc_date)
  }
end
