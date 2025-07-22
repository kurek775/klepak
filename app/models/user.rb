require "active_record/enum"

class User < ApplicationRecord
  has_many :user_accounts, dependent: :destroy

  enum :role, { user: 0, admin: 1 }

  validates :role, presence: true

  def self.from_omniauth(auth)
    user_account = UserAccount.find_or_initialize_by(
      provider: auth.provider,
      provider_account_id: auth.uid,
    )

    user = user_account.user || User.find_or_initialize_by(email: auth.info.email)

    user.assign_attributes(
      name: auth.info.name,
      avatar_url: auth.info.image,
      role: user.role || :user, # default to 'user' if not set
    )
    user.save!

    user_account.assign_attributes(
      user: user,
      access_token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token,
      expires_at: Time.at(auth.credentials.expires_at).to_datetime,
      scope: auth.credentials.scope,
      token_type: "Bearer",
      auth_protocol: "oauth2",
    )
    user_account.save!

    user
  end
end
