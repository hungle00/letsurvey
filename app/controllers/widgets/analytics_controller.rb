class Widgets::AnalyticsController < ApplicationController
  before_action :set_widget

  def show
    @questions = @widget.questions.order(:position)

    # Demo analytics data
    @total_responses = @widget.responses_count || 0
    @completion_rate = @total_responses > 0 ? rand(75..95) : 0
    @average_time = @total_responses > 0 ? "#{rand(2..8)} min" : "-"
    @total_views = @total_responses > 0 ? (@total_responses * rand(1.5..3.0)).to_i : 0

    # Demo response trends (last 7 days)
    @response_trends = (0..6).map do |i|
      {
        date: (Date.today - i.days).strftime("%b %d"),
        count: @total_responses > 0 ? rand(0..(@total_responses / 3)) : 0
      }
    end.reverse

    # Demo question statistics
    @question_stats = @questions.map do |question|
      {
        question: question,
        response_count: @total_responses > 0 ? rand(0..@total_responses) : 0,
        completion_rate: @total_responses > 0 ? rand(80..100) : 0
      }
    end
  end

  private

  def set_widget
    @widget = Current.user.widgets.find(params[:widget_id])
  end
end
