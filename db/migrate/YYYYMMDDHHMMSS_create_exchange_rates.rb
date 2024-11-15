class CreateExchangeRates < ActiveRecord::Migration[7.0]
    def change
      create_table :exchange_rates do |t|
        t.string :source_currency, null: false
        t.string :target_currency, null: false
        t.decimal :rate, precision: 10, scale: 6, null: false
        
        t.timestamps
        
        t.index [:source_currency, :target_currency], unique: true
      end
    end
  end