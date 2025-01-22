# Base controller for all the other controllers
# - Global Exception handler
# - Permission check logic
class ApplicationController < ActionController::API
  # define global exception handlers
  rescue_from StandardError, with: :handle_internal_error

  public
  # check if the admin user has logged in
  # Some API can only be executed by admins
  def is_admin_login
    token = request.headers["Authorization"]&.split(" ")&.last
    return false unless token.present?

    begin
      puts token
      decoded_token = JwtHelper.decode(token)
      puts decoded_token
      user_id = decoded_token["user_id"]
      AdminUser.exists?(id: user_id)
    rescue JWT::DecodeError
      false
    end
  end

  private
  def handle_internal_error(exception)
    Rails.logger.error(exception.message)
    Rails.logger.error(exception.backtrace.join("\n"))
    render json: BaseResultDto.failed("Internal error"), status: :internal_server_error
  end
end
