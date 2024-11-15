class AddStatusAndTypeToTransactions < ActiveRecord::Migration[7.0]
  def change
    # Add columns only if they don't exist
    unless column_exists?(:transactions, :status)
      add_column :transactions, :status, :integer, default: 0, null: false
    end

    unless column_exists?(:transactions, :transaction_type)
      add_column :transactions, :transaction_type, :integer, default: 0, null: false
    end

    unless column_exists?(:transactions, :description)
      add_column :transactions, :description, :string, null: false
    end

    # Add indexes only if they don't exist
    unless index_exists?(:transactions, :status)
      add_index :transactions, :status
    end

    unless index_exists?(:transactions, :transaction_type)
      add_index :transactions, :transaction_type
    end
  end
end