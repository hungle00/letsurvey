# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    name { "Test Plan" }
    max_widgets { 10 }
    monthly_price { 100 }
  end
end
