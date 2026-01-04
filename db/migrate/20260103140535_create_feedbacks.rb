class CreateFeedbacks < ActiveRecord::Migration[8.0]
  def change
    create_table :feedbacks do |t|
      t.references :widget, null: false, foreign_key: true
      t.string :respondent_email
      t.boolean :is_completed, default: false
      t.string :ip_address
      t.string :session_token
      t.datetime :submitted_at

      t.timestamps
    end

    add_index :feedbacks, :respondent_email
  end
end
