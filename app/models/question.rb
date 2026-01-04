class Question < ApplicationRecord
  belongs_to :widget, counter_cache: true
  has_many :options, class_name: "QuestionOption", dependent: :destroy
  has_many :answers, class_name: "FeedbackAnswer", dependent: :destroy

  accepts_nested_attributes_for :options, allow_destroy: true, reject_if: :all_blank

  attr_accessor :linked_product_id

  validates :question_type, presence: true
  validates :question_text, presence: true
  validates :position, numericality: { only_integer: true, greater_or_equal_to: 0 }, allow_blank: true

  enum :question_type, {
    rating: "rating",
    single_choice: "single_choice",
    multiple_choice: "multiple_choice",
    text: "text"
  }

  private

  def all_blank(attributes)
    attributes["option_text"].blank?
  end
end
