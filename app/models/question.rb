class Question < ApplicationRecord
  belongs_to :widget

  validates :question_type, presence: true
  validates :question_text, presence: true
  validates :position, numericality: { only_integer: true, greater_or_equal_to: 0 }, allow_blank: true

  enum :question_type, {
    rating: "rating",
    single_choice: "single_choice",
    multiple_choice: "multiple_choice",
    text: "text"
  }
end
