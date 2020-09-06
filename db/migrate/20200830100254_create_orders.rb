class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, index: true
      t.references :plan, null: false, index: true
      t.string :merchant_uid, index: true
      t.string :imp_uid, index: true
      t.integer :amount

      t.timestamps
    end
  end
end
