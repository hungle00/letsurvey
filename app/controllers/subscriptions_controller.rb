class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [ :show ]

  def show
    @subscription = Current.user.subscription
    @plans = Plan.all.order(:monthly_price)
  end

  def create
    if Current.user.subscription.present?
      redirect_to subscription_path, alert: "You already have an active subscription."
      return
    end

    @subscription = Current.user.build_subscription(subscription_params)

    # Set default values based on plan
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
    @plans = Plan.all.order(:monthly_price) if @subscription.nil?
  end

  def subscription_params
    params.require(:subscription).permit(:brand, :plan_id, :subscription_start_date, :subscription_end_date, :trial_end_date)
  end

  def set_subscription_defaults
    @subscription.status = "active"
    @subscription.subscription_start_date ||= Date.current

    if @subscription.plan.present?
      # Free plan doesn't expire
      if @subscription.plan.monthly_price.zero?
        @subscription.subscription_end_date = nil
      else
        @subscription.subscription_end_date ||= 1.year.from_now.to_date
      end
    end
  end

  def create_payment
    @subscription = Current.user.subscription

    if @subscription.nil?
      redirect_to subscription_path, alert: "You need to create a subscription first."
      return
    end

    vnpay_service = VnpayService.new(@subscription)
    payment_url = vnpay_service.create_payment_url

    redirect_to payment_url, alert: "Redirecting to payment gateway..."
  end
end
