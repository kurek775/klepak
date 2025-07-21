class User < ApplicationRecord
  has_many :user_accounts, dependent: :destroy

  def self.from_omniauth(auth)
    user_account = UserAccount.find_or_initialize_by(
      provider: auth.provider,
      provider_account_id: auth.uid
    )

    user = user_account.user || User.find_or_initialize_by(email: auth.info.email)

    user.name = auth.info.name
    user.avatar_url = auth.info.image
    user.save!

    user_account.user = user
    user_account.access_token = auth.credentials.token
    user_account.refresh_token = auth.credentials.refresh_token
    user_account.expires_at = Time.at(auth.credentials.expires_at).to_datetime
    user_account.scope = auth.credentials.scope
    user_account.token_type = "Bearer"
    user_account.auth_protocol = "oauth2"
    user_account.save!

    user
  end
end
