class FormsController < ApplicationController
  # Public form - no authentication required
  allow_unauthenticated_access only: :show

  before_action :set_widget

  def show
    # Only show published widgets
    unless @widget.published?
      redirect_to root_path, alert: "This survey is not available."
      return
    end

    @questions = @widget.questions.includes(:options).order(:position)
  end

  private

  def set_widget
    @widget = Widget.find_by!(slug: params[:slug])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Survey not found."
  end
end
