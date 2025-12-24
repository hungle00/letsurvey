class CreateQuestionOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :question_options do |t|
      t.references :question, null: false, foreign_key: true
      t.string :option_text, null: false
      t.integer :position, default: 1

      t.timestamps
    end
  end
end
