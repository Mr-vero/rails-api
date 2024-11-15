class CreateTokenBlacklist < ActiveRecord::Migration[7.1]
  def change
    create_table :token_blacklists do |t|
      t.string :token
      t.datetime :expires_at

      t.timestamps
    end
    add_index :token_blacklists, :token, unique: true
  end
end
