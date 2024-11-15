class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.string :symbol

      t.timestamps
    end
    add_index :stocks, :symbol
  end
end
