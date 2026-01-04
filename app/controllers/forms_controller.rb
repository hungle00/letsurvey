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

  def submit
    @feedback = @widget.feedbacks.build(
      respondent_email: params[:respondent_email],
      ip_address: request.remote_ip,
      session_token: session.id.private_id,
      submitted_at: Time.current,
      is_completed: true
    )

    if @feedback.save
      redirect_to thank_you_widget_form_path(@widget.slug), notice: "Thank you for your feedback!"
    else
      @questions = @widget.questions.includes(:options).order(:position)
      render :show, status: :unprocessable_entity
    end
  end

  def thanks
  end

  private

  def set_widget
    @widget = Widget.find_by!(slug: params[:slug])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Survey not found."
  end
end
