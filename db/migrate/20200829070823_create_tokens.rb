class CreateTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :tokens do |t|
      t.references :user, index: true, null: false
      t.string :access_token, null: false, index: {unique: true}
      t.datetime :last_accessed_at, index: true, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamps
    end
  end
end
