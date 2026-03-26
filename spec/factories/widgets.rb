# frozen_string_literal: true

FactoryBot.define do
  factory :widget do
    association :user

    sequence(:title) { |n| "Widget #{n}" }
    sequence(:slug) { |n| "widget-#{n}" }

    description { "A widget used in tests" }
    status { "draft" }
    require_email { false }

    start_date { Date.current }
    end_date { Date.current + 30.days }
    max_responses { 100 }
  end
end

