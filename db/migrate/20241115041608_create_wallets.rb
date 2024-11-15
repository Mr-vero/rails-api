class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.references :owner, polymorphic: true, null: false
      t.integer :balance_cents, default: 0, null: false
      t.string :currency, null: false, default: 'USD'
      
      t.timestamps
      
      t.index [:owner_type, :owner_id]
    end
  end
end