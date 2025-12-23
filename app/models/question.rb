class Question < ApplicationRecord
  belongs_to :widget

  validates :question_type, presence: true
  validates :question_text, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }

  enum :question_type, {
    rating: "rating",
    single_choice: "single_choice",
    multiple_choice: "multiple_choice",
    text: "text",
    email: "email",
    number: "number",
    date: "date"
  }
end
