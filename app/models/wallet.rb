class Wallet < ApplicationRecord
    belongs_to :owner, polymorphic: true
    has_many :source_transactions, class_name: 'Transaction', foreign_key: 'source_wallet_id'
    has_many :target_transactions, class_name: 'Transaction', foreign_key: 'target_wallet_id'
    
    validates :balance_cents, presence: true, numericality: { only_integer: true }
    validates :currency, presence: true
    
    def balance
      Money.new(balance_cents, currency)
    end
    
    def calculate_balance
      credits = target_transactions.sum(:amount_cents)
      debits = source_transactions.sum(:amount_cents)
      self.balance_cents = credits - debits
      save!
    end
  end