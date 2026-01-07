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
    return false unless subscription_start_date.present?

    # If subscription_end_date is nil, it's a lifetime subscription (e.g., Free plan)
    return true if subscription_end_date.nil?

    # Check if subscription is active and not expired
    subscription_start_date <= Date.current &&
      subscription_end_date >= Date.current &&
      active?
  end

  def widgets_count
    user.widgets.count
  end

  def can_create_widget?
    is_subscribed? && widgets_count < plan&.widgets_limit
  end
end
