module QuestionsHelper
  def question_type_options
    [
      [ "Rating", "rating" ],
      [ "Single Choice", "single_choice" ],
      [ "Multiple Choice", "multiple_choice" ],
      [ "Text", "text" ]
    ]
  end

  def product_options
    subscription = Current.user.subscription
    return [] unless subscription.present?

    subscription.products.active.pluck(:name, :id)
  end
end
