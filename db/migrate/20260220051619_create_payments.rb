class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subscription, null: true, foreign_key: true

      # ZaloPay: merchant order reference (unique), format e.g. yymmdd_xxx
      t.string :app_trans_id, limit: 100, null: false
      # ZaloPay transaction id (from callback)
      t.string :zp_trans_id, limit: 50
      # Amount in VND
      t.integer :amount, null: false
      # pending: 0, success: 1, failed: 2, cancelled: 3
      t.integer :status, null: false, default: 0
      # ZaloPay callback return_code / sub_return_code
      t.string :return_code, limit: 20
      t.string :bank_code, limit: 50
      # Raw callback payload (JSON string)
      t.text :callback_data
      # Our metadata: duration_days, service, plan_id, etc. (JSON string)
      t.text :return_data

      t.datetime :paid_at

      t.timestamps
    end

    add_index :payments, :app_trans_id, unique: true
  end
end
