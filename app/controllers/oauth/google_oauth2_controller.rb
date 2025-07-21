class OAuth::GoogleOauth2Controller < ApplicationController
  def callback
    auth = request.env['omniauth.auth']
    origin = request.env['omniauth.origin']

    user_account = UserAccount.find_or_initialize_by(
      provider: auth.provider,
      provider_account_id: auth.uid
    )

    # Find or create the associated user
    user = user_account.user || User.find_or_initialize_by(email: auth.info.email)
    user.name = auth.info.name
    user.avatar_url = auth.info.image
    user.save!

    # Associate user with user_account before saving
    user_account.user = user
    user_account.attributes = {
      access_token: auth.credentials.token,
      auth_protocol: "oauth2",
      expires_at: Time.at(auth.credentials.expires_at).to_datetime,
      refresh_token: auth.credentials.refresh_token,
      scope: auth.credentials.scope,
      token_type: "Bearer"
    }

    user_account.save!

    session[:user_account_id] = user_account.id

    Rails.logger.info "✅ User #{user.email} logged in via #{user_account.provider}"
    redirect_to origin || root_path, notice: "Signed in successfully!"
  end
end
