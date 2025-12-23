class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [ :show ]

  def show
    @subscription = Current.user.subscription
  end

  def create
    if Current.user.subscription.present?
      redirect_to subscription_path, alert: "You already have an active subscription."
      return
    end

    @subscription = Current.user.build_subscription(subscription_params)

    # Set default values based on account type
    set_subscription_defaults

    if @subscription.save
      redirect_to subscription_path, notice: "Subscription created successfully!"
    else
      redirect_to subscription_path, alert: "Failed to create subscription: #{@subscription.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_subscription
    @subscription = Current.user.subscription
  end

  def subscription_params
    params.require(:subscription).permit(:brand, :account_type, :subscription_start_date, :subscription_end_date, :trial_end_date)
  end

  def set_subscription_defaults
    @subscription.status = "active"
    @subscription.subscription_start_date ||= Date.current

    case @subscription.account_type
    when "free"
      @subscription.max_widgets = 3
      @subscription.subscription_end_date = nil # Free plan doesn't expire
    when "regular"
      @subscription.max_widgets = 10
      @subscription.subscription_end_date ||= 1.year.from_now.to_date
    when "premium"
      @subscription.max_widgets = nil # Unlimited
      @subscription.subscription_end_date ||= 1.year.from_now.to_date
    end
  end
end
