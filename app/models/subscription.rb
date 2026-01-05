class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan, optional: true
  has_many :products, dependent: :destroy

  enum :status, {
    active: "active",
    inactive: "inactive",
    expired: "expired",
    cancelled: "cancelled"
  }

  def is_in_trial?
    trial_end_date.present? && trial_end_date > Date.current
  end

  def is_subscribed?
    subscription_start_date.present? && subscription_end_date.present? &&
      subscription_start_date <= Date.current
  end
end
