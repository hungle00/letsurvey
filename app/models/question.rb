class Question < ApplicationRecord
  belongs_to :widget, counter_cache: true
  has_many :options, class_name: "QuestionOption", dependent: :destroy
  has_many :answers, class_name: "FeedbackAnswer", dependent: :destroy

  accepts_nested_attributes_for :options, allow_destroy: true, reject_if: :all_blank

  attr_accessor :linked_product_id

  validates :question_type, presence: true
  validates :question_text, presence: true
  validates :position, numericality: { only_integer: true, greater_or_equal_to: 0 }, allow_blank: true

  enum :question_type, {
    rating: "rating",
    single_choice: "single_choice",
    multiple_choice: "multiple_choice",
    text: "text"
  }

  # Calculate average rating for a rating question
  def average_rating
    ratings = answers.where.not(answer_rating: nil).pluck(:answer_rating)

    return nil if ratings.empty?

    ratings.sum.to_f / ratings.size
  end

  # Find the most chosen option for single_choice or multiple_choice question
  def most_chosen_option
    answer_texts = answers.where.not(answer_text: nil)
                          .where.not(answer_text: "")
                          .pluck(:answer_text)

    return nil if answer_texts.empty?

    # Count occurrences of each option
    option_counts = answer_texts.each_with_object(Hash.new(0)) do |option_text, counts|
      counts[option_text] += 1
    end

    # Find the option with the highest count
    most_chosen = option_counts.max_by { |_option, count| count }

    {
      option_text: most_chosen[0],
      count: most_chosen[1]
    }
  end

  private

  def all_blank(attributes)
    attributes["option_text"].blank?
  end
end
