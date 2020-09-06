class AddStatusToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :status, :integer, null: false, index: true, default: 0
  end
end
