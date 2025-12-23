class CreateWidgets < ActiveRecord::Migration[8.0]
  def change
    create_table :widgets do |t|
      t.string :title, null: false
      t.text :description
      t.string :slug, null: false
      t.string :status, default: "draft"
      t.boolean :require_email, default: false
      t.datetime :start_date
      t.datetime :end_date
      t.integer :max_responses
      t.integer :responses_count, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :widgets, :slug, unique: true
  end
end
