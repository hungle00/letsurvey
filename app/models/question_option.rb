class QuestionOption < ApplicationRecord
  belongs_to :question

  validates :option_text, presence: true
  validates :position, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true

  scope :ordered, -> { order(position: :asc) }

  before_validation :set_default_position, on: :create

  private

  def set_default_position
    self.position = question.question_options.count + 1
  end
end
