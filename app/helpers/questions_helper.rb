module QuestionsHelper
  def question_type_options
    [
      [ "Rating", "rating" ],
      [ "Single Choice", "single_choice" ],
      [ "Multiple Choice", "multiple_choice" ],
      [ "Text", "text" ]
    ]
  end
end
