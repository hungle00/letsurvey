class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :subscription, optional: true

  enum :status, { pending: 0, success: 1, failed: 2, cancelled: 3 }
end
