class Statistic
  def self.count_answers_by_question(widget)
    # Count answers for each question in this widget
    FeedbackAnswer.joins(:feedback, :question)
                  .where(feedbacks: { widget_id: widget.id })
                  .group(:question_id)
                  .count
  end
end
