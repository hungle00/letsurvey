class Feedback < ApplicationRecord
  belongs_to :widget

  has_many :feedback_answers, dependent: :destroy

  validates :respondent_email, presence: true, if: -> { widget.present? && widget.require_email? }
  validates :respondent_email, uniqueness: { scope: :widget_id, message: "has already been used for this survey" }, if: -> { respondent_email.present? && widget.present? }

  after_create :update_widget_response_count

  private

  def update_widget_response_count
    widget.increment!(:responses_count)
  end
end
