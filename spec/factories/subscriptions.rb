# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    association :user
    association :plan

    brand { "Test Brand" }
    status { "active" }
    subscription_start_date { Date.current }
    subscription_end_date { Date.current + 1.year }
    trial_end_date { Date.current + 1.month }
  end
end
