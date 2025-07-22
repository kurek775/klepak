class LoginController < ApplicationController
  def new
    redirect_to current_user.admin? ? users_path : home_path if current_user
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.from_omniauth(auth)
    session[:user_id] = user.id

    redirect_to user.admin? ? users_path : home_path
  end
end
