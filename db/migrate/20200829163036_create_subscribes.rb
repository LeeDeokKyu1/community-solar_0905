class CreateSubscribes < ActiveRecord::Migration[6.0]
  def change
    create_table :subscribes do |t|
      t.references :user, null: false, index: true
      t.references :order, index: true
      t.references :plan, index: true, null: false

      t.datetime :start_at, index: true
      t.datetime :end_at, index: true
      t.timestamps
    end
  end
end
