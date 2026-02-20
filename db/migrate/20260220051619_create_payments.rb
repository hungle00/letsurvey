class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subscription, null: true, foreign_key: true
      t.string :vnp_TxnRef, null: false
      t.string :vnp_TransactionNo
      t.float :amount, null: false
      t.integer :status, null: false, default: 0
      t.string :vnp_ResponseCode
      t.string :vnp_BankCode
      t.text :ipn_data
      t.text :return_data
      t.datetime :paid_at

      t.timestamps
    end
  end
end
