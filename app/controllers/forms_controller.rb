class FormsController < ApplicationController
  # Public form - no authentication required
  allow_unauthenticated_access only: [ :show, :submit, :thanks ]

  before_action :set_widget

  def show
    # Only show published widgets
    unless @widget.published?
      redirect_to root_path, alert: "This survey is not available."
      return
    end

    @questions = @widget.questions.includes(:options).order(:position)
    @feedback = @widget.feedbacks.build
  end

  def submit
    @feedback = @widget.feedbacks.build(
      respondent_email: params[:respondent_email],
      ip_address: request.remote_ip,
      session_token: session.id.private_id,
      submitted_at: Time.current,
      is_completed: true
    )

    # Validate feedback first (before transaction)
    unless @feedback.valid?
      @questions = @widget.questions.includes(:options).order(:position)
      render :show, status: :unprocessable_entity
      return
    end

    success = false
    ActiveRecord::Base.transaction do
      if @feedback.save
        # Create feedback answers for each question
        @widget.questions.includes(:options).order(:position).each do |question|
          create_feedback_answers(@feedback, question)
        end
        success = true
      end
    end

    if success
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

  def create_feedback_answers(feedback, question)
    case question.question_type
    when "rating"
      rating_value = params["question_#{question.id}"]
      if rating_value.present?
        feedback.feedback_answers.create!(
          question: question,
          answer_rating: rating_value.to_i
        )
      end

    when "single_choice"
      selected_value = params["question_#{question.id}"]
      if selected_value.present?
        if selected_value == "other"
          # Handle "other" option
          other_text = params["question_#{question.id}_other"]
          feedback.feedback_answers.create!(
            question: question,
            answer_text: "other",
            answer_other: other_text
          )
        else
          # Store the selected option ID
          option = question.options.find_by(id: selected_value)
          if option
            feedback.feedback_answers.create!(
              question: question,
              answer_text: option.option_text
            )
          end
        end
      end

    when "multiple_choice"
      selected_values = params["question_#{question.id}"] || []
      selected_values = [ selected_values ] unless selected_values.is_a?(Array)

      selected_values.each do |selected_value|
        next if selected_value.blank?

        if selected_value == "other"
          # Handle "other" option
          other_text = params["question_#{question.id}_other"]
          feedback.feedback_answers.create!(
            question: question,
            answer_text: "other",
            answer_other: other_text
          )
        else
          # Store the selected option
          option = question.options.find_by(id: selected_value)
          if option
            feedback.feedback_answers.create!(
              question: question,
              answer_text: option.option_text
            )
          end
        end
      end

    when "text"
      answer_text = params["question_#{question.id}"]
      if answer_text.present?
        feedback.feedback_answers.create!(
          question: question,
          answer_text: answer_text
        )
      end
    end
  end
end
