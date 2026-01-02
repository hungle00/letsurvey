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
    Product.list.map { |product| [ product.name, product.id ] }
  end
end
