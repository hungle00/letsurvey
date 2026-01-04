class CreateFeedbackAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :feedback_answers do |t|
      t.references :feedback, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.text :answer_text
      t.integer :answer_rating
      t.text :answer_other

      t.timestamps
    end

    add_index :feedback_answers, [ :feedback_id, :question_id ], unique: true
  end
end
