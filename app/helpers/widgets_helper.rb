module WidgetsHelper
  def status_badge_class(status)
    case status
    when "draft"
      "bg-gray-100 text-gray-700"
    when "published"
      "bg-green-100 text-green-700"
    when "closed"
      "bg-yellow-100 text-yellow-700"
    when "archived"
      "bg-gray-200 text-gray-600"
    else
      "bg-gray-100 text-gray-700"
    end
  end
end

