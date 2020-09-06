class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans do |t|
      t.integer :plan_type, null: false, index: true
      t.integer :capacity, default: 0
      t.integer :price
      t.string :name
      t.timestamps
    end
  end
end
