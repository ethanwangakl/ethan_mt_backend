# Admin users login
# Only Admin users can view the full mood history of everybody
class AdminUsersController < ApplicationController

  # Login user as an Admin user using JWT.
  # A token will be generated and returned back to the frontend.
  # The frontend need to set the token into the header like Authorization: Bearer: ********
  def login
    username = params[:username]
    admin_user = AdminUser.find_by(username: username)

    if admin_user.nil?
      return render json: BaseResultDto.failed("Authenticate failed"), status: :not_found
    end

    if admin_user.authenticate(params[:password])
      token = JwtHelper.encode({ user_id: admin_user.id })
      render json: { token: token, username: username }, status: :ok
    else
      render json: BaseResultDto.failed("Authenticate failed"), status: :internal_server_error
    end
  end
end
