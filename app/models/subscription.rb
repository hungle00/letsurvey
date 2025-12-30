class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan, optional: true

  enum :status, {
    active: "active",
    inactive: "inactive",
    expired: "expired",
    cancelled: "cancelled"
  }
end
