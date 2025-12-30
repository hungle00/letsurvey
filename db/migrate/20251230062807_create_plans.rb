class CreatePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.integer :max_widgets
      t.decimal :monthly_price, null: false

      t.timestamps
    end
  end
end
