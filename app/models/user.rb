class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :widgets, dependent: :destroy
  has_one :subscription, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def has_active_subscription?
    return false unless subscription.present?

    subscription.is_subscribed? || subscription.is_in_trial?
  end
end
