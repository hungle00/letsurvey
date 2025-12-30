class Plan < ApplicationRecord
  has_many :subscriptions, dependent: :nullify

  validates :name, presence: true
  validates :monthly_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
