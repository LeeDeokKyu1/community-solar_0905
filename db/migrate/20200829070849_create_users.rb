class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.integer :login_provider, index: true, null: false
      t.string :login_user_id, index: true, null: false
      t.string :password_digest
      t.string :householder_name, null: false
      t.string :name, null: false
      t.string :phone_number
      t.string :apt_name, null: false
      t.string :building_number, null: false
      t.string :building_line_number, null: false
      t.boolean :active, index: true, default: true
      t.timestamps
    end
  end
end
