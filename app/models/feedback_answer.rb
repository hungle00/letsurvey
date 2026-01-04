class FeedbackAnswer < ApplicationRecord
  belongs_to :feedback
  belongs_to :question
end
