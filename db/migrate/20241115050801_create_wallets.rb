class CreateWallets < ActiveRecord::Migration[7.1]
  def change
    create_table :wallets do |t|
      t.references :owner, polymorphic: true, null: false
      t.integer :balance_cents
      t.string :currency

      t.timestamps
    end
  end
end
