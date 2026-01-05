class Product < ApplicationRecord
  belongs_to :subscription

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true

  enum :status, {
    active: "active",
    inactive: "inactive",
    archived: "archived"
  }
end
