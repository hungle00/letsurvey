class Subscription < ApplicationRecord
  belongs_to :user

  validates :account_type, presence: true

  enum :account_type, {
    premium: "premium",
    regular: "regular",
    free: "free"
  }

  enum :status, {
    active: "active",
    inactive: "inactive",
    expired: "expired",
    cancelled: "cancelled"
  }
end
