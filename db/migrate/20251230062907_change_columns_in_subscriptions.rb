class ChangeColumnsInSubscriptions < ActiveRecord::Migration[8.0]
  def change
    remove_column :subscriptions, :max_widgets, :integer
    remove_column :subscriptions, :account_type, :string

    # Add plan_id as nullable (optional: true)
    add_reference :subscriptions, :plan, null: true, foreign_key: true
  end
end
