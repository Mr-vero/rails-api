class CreateTransactions < ActiveRecord::Migration[7.0]
    def change
      create_table :transactions do |t|
        t.references :source_wallet, foreign_key: { to_table: :wallets }
        t.references :target_wallet, foreign_key: { to_table: :wallets }
        t.integer :amount_cents, null: false
        t.string :currency, null: false
        t.integer :status, default: 0, null: false
        t.integer :transaction_type, default: 0, null: false
        t.string :description, null: false
        
        t.timestamps
        
        t.index :status
        t.index :transaction_type
      end
    end
  end