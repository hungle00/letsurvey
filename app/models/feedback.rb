class Feedback < ApplicationRecord
  belongs_to :widget

  has_many :feedback_answers, dependent: :destroy

  after_create :update_widget_response_count

  private

  def update_widget_response_count
    widget.increment!(:responses_count)
  end
end
