class WalletTransactionService
    def self.transfer(source_wallet:, target_wallet:, amount:)
      return false if amount <= 0
      
      ActiveRecord::Base.transaction do
        Transaction.create!(
          source_wallet: source_wallet,
          target_wallet: target_wallet,
          amount_cents: amount.cents,
          currency: amount.currency.iso_code
        )
      end
    end
    
    def self.deposit(wallet:, amount:)
      return false if amount <= 0
      
      ActiveRecord::Base.transaction do
        Transaction.create!(
          target_wallet: wallet,
          amount_cents: amount.cents,
          currency: amount.currency.iso_code
        )
      end
    end
    
    def self.withdraw(wallet:, amount:)
      return false if amount <= 0
      
      ActiveRecord::Base.transaction do
        Transaction.create!(
          source_wallet: wallet,
          amount_cents: amount.cents,
          currency: amount.currency.iso_code
        )
      end
    end
  end