class Widgets::QuestionsController < ApplicationController
  before_action :set_widget

  def index
    @questions = @widget.questions.order(:position)
    @question = @widget.questions.build
  end

  def new
    @question = @widget.questions.build
  end

  def edit
    @question = @widget.questions.find(params[:id])
  end

  def update
    @question = @widget.questions.find(params[:id])

    if @question.update(question_params)
      render partial: "question", locals: { question: @question, widget: @widget }, status: :ok
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @question = @widget.questions.build(question_params)

    if @question.save
      redirect_to widget_questions_path(@widget), notice: "Question was successfully created."
    else
      @questions = @widget.questions.order(:position)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_widget
    @widget = Current.user.widgets.find(params[:widget_id])
  end

  def question_params
    params.require(:question).permit(:question_text, :question_type, :required, :position, :allow_other, :min_value, :max_value, :placeholder)
  end
end
