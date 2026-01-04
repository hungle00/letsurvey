class WidgetsController < ApplicationController
  before_action :set_widget, only: [ :show, :edit, :update, :destroy ]

  def index
    @widgets = Current.user.widgets.order(created_at: :desc)
  end

  def show
  end

  def preview
    @widget = Current.user.widgets.find(params[:id])
    @questions = @widget.questions.includes(:options).order(:position)
  end

  def new
    @widget = Current.user.widgets.build
  end

  def create
    @widget = Current.user.widgets.build(widget_params)

    if @widget.save
      redirect_to widget_questions_path(@widget), notice: "Widget was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @widget.update(widget_params)
      redirect_to @widget, notice: "Widget was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @widget.destroy
    redirect_to widgets_path, notice: "Widget was successfully deleted."
  end

  private

  def set_widget
    @widget = Current.user.widgets.find(params[:id])
  end

  def widget_params
    params.require(:widget).permit(:title, :description, :status, :require_email, :start_date, :end_date, :max_responses)
  end
end
