module SubscriptionAccess
  extend ActiveSupport::Concern

  private

  def check_subscription_access
    unless Current.user.has_active_subscription?
      redirect_to subscription_path, alert: "You need an active subscription or trial to create widgets. Please subscribe to a plan first."
    end
  end
end
