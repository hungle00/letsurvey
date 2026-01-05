class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.string :category
      t.decimal :price, null: false
      t.string :status, default: "active"
      t.integer :image_url
      t.references :subscription, null: false, foreign_key: true

      t.timestamps
    end
  end
end
