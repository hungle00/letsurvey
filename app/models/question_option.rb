class QuestionOption < ApplicationRecord
  belongs_to :question

  validates :option_text, presence: true, if: :requires_options?
  validates :position, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true

  scope :ordered, -> { order(position: :asc) }

  before_validation :set_default_position, on: :create

  private

  def set_default_position
    self.position = question.options.count + 1
  end

  def requires_options?
    question.present? && (question.single_choice? || question.multiple_choice?)
  end
end
