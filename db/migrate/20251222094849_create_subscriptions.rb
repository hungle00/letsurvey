class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :brand
      t.string :account_type, null: false
      t.string :status, default: "active"
      t.date :subscription_start_date
      t.date :subscription_end_date
      t.date :trial_end_date
      t.integer :max_widgets

      t.timestamps
    end
  end
end
