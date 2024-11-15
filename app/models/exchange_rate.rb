class ExchangeRate < ApplicationRecord
    validates :source_currency, presence: true
    validates :target_currency, presence: true
    validates :rate, presence: true, numericality: { greater_than: 0 }
    
    def self.convert(amount, from:, to:)
      return amount if from == to
      
      rate = find_by(source_currency: from, target_currency: to)&.rate ||
             1.0 / find_by(source_currency: to, target_currency: from)&.rate
      
      raise "No exchange rate found for #{from} to #{to}" unless rate
      
      Money.new((amount.cents * rate).round, to)
    end
  end