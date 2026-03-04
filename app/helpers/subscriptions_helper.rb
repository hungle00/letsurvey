module SubscriptionsHelper
  def subscription_status_badge_class(status)
    case status
    when "active"
      "bg-green-100 text-green-700"
    when "inactive"
      "bg-gray-100 text-gray-700"
    when "expired"
      "bg-red-100 text-red-700"
    when "cancelled"
      "bg-yellow-100 text-yellow-700"
    else
      "bg-gray-100 text-gray-700"
    end
  end
end
