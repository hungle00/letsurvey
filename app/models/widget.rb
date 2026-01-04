class Widget < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  has_many :questions, dependent: :destroy
  has_many :feedbacks, dependent: :nullify

  enum :status, {
    draft: "draft",
    published: "published",
    closed: "closed",
    archived: "archived"
  }

  before_validation :generate_slug, on: :create

  private

  def generate_slug
    return if slug.present?

    base_slug = title.parameterize
    self.slug = base_slug
    counter = 1
    while Widget.exists?(slug: self.slug)
      self.slug = "#{base_slug}-#{counter}"
      counter += 1
    end
  end
end
