class AnalyticsController < ApplicationController
  def index
    @widgets = Current.user.widgets.order(created_at: :desc)
  end
end
