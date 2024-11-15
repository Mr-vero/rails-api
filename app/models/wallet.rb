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
      credits = target_transactions.completed.sum(:amount_cents)
      debits = source_transactions.completed.sum(:amount_cents)
      self.balance_cents = credits - debits
      save!
    end
    
    def convert_balance_to(target_currency)
      ExchangeRate.convert(balance, from: currency, to: target_currency)
    end
    
    def transactions
      Transaction.where('source_wallet_id = ? OR target_wallet_id = ?', id, id)
                .order(created_at: :desc)
    end
    
    def pending_transactions
      transactions.pending
    end
    
    def completed_transactions
      transactions.completed
    end
    
    def failed_transactions
      transactions.failed
    end
  end