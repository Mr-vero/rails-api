class CreateTransactions < ActiveRecord::Migration[7.0]
    def change
      create_table :transactions do |t|
        t.references :source_wallet, null: true, foreign_key: { to_table: :wallets }
        t.references :target_wallet, null: true, foreign_key: { to_table: :wallets }
        t.integer :amount_cents, null: false
        t.string :currency, null: false
        
        t.timestamps
      end
    end
  end