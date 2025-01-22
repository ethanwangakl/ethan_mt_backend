# User mood APIs including:
# - Create new mood for today
# - List my own moods (No Authentication implemented as required, so it's kind of fake actually)
# - List all the users' mood histories (Admin permission needed)
class UserMoodsController < ApplicationController

  # Create today's new mood
  # No authentication, so I have to pass a username from the frontend to fake one
  def create
    username = params[:username]
    comment = params[:comment]
    mood = MoodEnum.mood_key_from_string(params[:mood_key])
    if mood == nil
      return render json: BaseResultDto.failed("Invalid mood key"), status: :bad_request
    end

    today_history = UserMood.find_by_username_and_date(username, Time.now.utc.to_date)
    puts today_history.empty?
    if today_history.present?
      return render json: BaseResultDto.failed("We have your mood today"), status: :bad_request
    end

    user_mood = UserMood.new(
      uuid: SecureRandom.uuid,
      username: username,
      mood: MoodEnum::MOODS[mood],
      comment: comment
    )
    if user_mood.save
      render json: UserMoodDto.from(user_mood), status: :created
    else
      errors = user_mood.errors.full_messages
      puts errors

      render json: BaseResultDto.failed("Failed to create user mood"), status: :internal_server_error
    end
  end

  # List all the mood histories of this user
  def index
    username = params[:username]
    user_moods = UserMood.find_by_username_and_mood(params[:username], nil)
    if user_moods.any?
      user_mood_dtos = user_moods.map do |user_mood|
        UserMoodDto.from(user_mood)
      end
      render json: user_mood_dtos, status: :ok
    else
      render json: BaseResultDto.failed("No user moods found for user #{username}"), status: :not_found
    end
  end

  # list all the user mood history
  # Only admin users can see the list
  def admin_index
    unless is_admin_login
      return render json: BaseResultDto.failed("Not admin log in"), status: :unauthorized
    end

    mood = nil
    if params[:mood_key]
      mood = MoodEnum.mood_key_from_string(params[:mood_key])
      if mood == nil
        return render json: BaseResultDto.failed("Invalid mood key"), status: :bad_request
      end
    end

    page = params[:page]
    per_page = params[:per_page]

    user_moods = UserMood.find_by_username_and_mood(params[:username],
                                                    MoodEnum::MOODS[mood],
                                                    page: page,
                                                    per_page: per_page)
    if user_moods.any?
      user_mood_dtos = user_moods.map do |user_mood|
        UserMoodDto.from(user_mood)
      end
      render json: user_mood_dtos, status: :ok
    else
      render json: BaseResultDto.failed("No user moods found"), status: :not_found
    end
  end

end
