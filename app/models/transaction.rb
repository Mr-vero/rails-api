class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true
  
  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validate :validate_wallets
  validate :validate_same_currency
  
  after_commit :update_wallet_balances
  
  private
  
  def validate_wallets
    if source_wallet.nil? && target_wallet.nil?
      errors.add(:base, "Either source or target wallet must be present")
    end
    
    if source_wallet.present? && target_wallet.present?
      if source_wallet == target_wallet
        errors.add(:base, "Source and target wallet cannot be the same")
      end
    end
  end
  
  def validate_same_currency
    wallets = [source_wallet, target_wallet].compact
    currencies = wallets.map(&:currency).uniq
    if currencies.size > 1
      errors.add(:base, "All wallets must use the same currency")
    end
  end
  
  def update_wallet_balances
    source_wallet&.calculate_balance
    target_wallet&.calculate_balance
  end
end
