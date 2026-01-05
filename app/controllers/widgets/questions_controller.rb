class Widgets::QuestionsController < ApplicationController
  include SubscriptionAccess

  before_action :set_widget
  before_action :check_subscription_access, only: [ :new, :create ]

  def index
    @questions = @widget.questions.order(:position)
    @question = @widget.questions.build
    @question.options.build
  end

  def new
    @question = @widget.questions.build
    @question.options.build
  end

  def edit
    @question = @widget.questions.includes(:options).find(params[:id])
    @question.options.build
  end

  def update
    @question = @widget.questions.includes(:options).find(params[:id])

    if @question.update(question_params)
      render partial: "question", locals: { question: @question, widget: @widget }, status: :ok
    else
      @question.options.build if @question.options.empty?
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @question = @widget.questions.build(question_params)

    if @question.save
      # Build new question for form reset
      new_question = @widget.questions.build
      # Render the newly created question and reset form
      render turbo_stream: [
        turbo_stream.append("questions_list", partial: "question", locals: { question: @question, widget: @widget }),
        turbo_stream.replace("new_question", partial: "new_question", locals: { question: new_question, widget: @widget })
      ]
    else
      render partial: "new_question", status: :unprocessable_entity, locals: { question: @question, widget: @widget }
    end
  end

  def destroy
    @question = @widget.questions.find(params[:id])
    @question.destroy

    render turbo_stream: turbo_stream.remove(ActionView::RecordIdentifier.dom_id(@question))
  end

  private

  def set_widget
    @widget = Current.user.widgets.find(params[:widget_id])
  end

  def question_params
    params.require(:question).permit(
      :question_text, :question_type, :required, :position, :allow_other,
      :min_value, :max_value, :placeholder, :linked_product_id,
      options_attributes: [ :option_text, :position, :_destroy, :id ]
    )
  end
end
