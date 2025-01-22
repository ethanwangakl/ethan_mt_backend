class UserMoodDto
  attr_accessor :uuid, :username, :mood, :comment, :created_at, :updated_at

  def initialize(uuid:, username:, mood:, comment:, created_at:, updated_at:)
    @uuid = uuid
    @username = username
    @mood = mood
    @comment = comment
    @created_at = created_at
    @updated_at = updated_at
  end

  def self.from(user_mood)
    UserMoodDto.new(uuid: user_mood.uuid,
                    username: user_mood.username,
                    mood: MoodEnum.key_from_value(user_mood.mood),
                    comment: user_mood.comment,
                    created_at: user_mood.created_at,
                    updated_at: user_mood.updated_at
    )
  end
end
