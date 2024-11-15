class AddStatusAndTypeToTransactions < ActiveRecord::Migration[7.0]
    def change
      add_column :transactions, :status, :integer, default: 0, null: false
      add_column :transactions, :transaction_type, :integer, default: 0, null: false
      add_column :transactions, :description, :string, null: false
      add_index :transactions, :status
      add_index :transactions, :transaction_type
    end
  end