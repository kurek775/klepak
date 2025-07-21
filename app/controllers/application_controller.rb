class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?
  allow_browser versions: :modern
  def current_user
    return @current_user if defined?(@current_user)

    if session[:user_account_id]
      user_account = UserAccount.includes(:user).find_by(id: session[:user_account_id])
      @current_user = user_account&.user
    else
      @current_user = nil
    end
  end

  def user_signed_in?
    current_user.present?
  end
end
