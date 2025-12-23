class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.references :widget, null: false, foreign_key: true
      t.string :question_type, null: false
      t.text :question_text, null: false
      t.boolean :required, default: false
      t.integer :position, default: 0
      t.boolean :allow_other, default: false
      t.integer :min_value
      t.integer :max_value
      t.string :placeholder

      t.timestamps
    end
  end
end
