# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    association :widget

    question_type { "single_choice" }
    question_text { "What is your favorite option?" }
    required { false }
    position { 0 }
    allow_other { false }
    placeholder { "Select one" }

    # min_value/max_value are optional depending on question_type
    min_value { nil }
    max_value { nil }
  end
end
