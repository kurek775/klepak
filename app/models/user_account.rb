class UserAccount < ApplicationRecord
  belongs_to :user

  def expired?
    expires_at.present? && expires_at < Time.zone.now
  end
end
