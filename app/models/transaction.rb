class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true
  
  enum :status, %i[pending completed failed]
  enum :transaction_type, %i[transfer deposit withdrawal]
  
  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :description, presence: true
  
  validate :validate_wallets
  validate :validate_same_currency
  validate :validate_transaction_limits
  validate :validate_business_hours
  
  after_commit :update_wallet_balances, if: :completed?
  after_create :log_transaction_creation
  after_update :log_status_change, if: :saved_change_to_status?
  
  class << self
    attr_accessor :skip_business_hours_validation
  end
  
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
    
    validate_wallet_presence_for_type
  end
  
  def validate_wallet_presence_for_type
    case transaction_type
    when 'transfer'
      errors.add(:base, "Transfer requires both source and target wallets") unless source_wallet && target_wallet
    when 'deposit'
      errors.add(:base, "Deposit requires target wallet") unless target_wallet && source_wallet.nil?
    when 'withdrawal'
      errors.add(:base, "Withdrawal requires source wallet") unless source_wallet && target_wallet.nil?
    end
  end
  
  def validate_same_currency
    wallets = [source_wallet, target_wallet].compact
    currencies = wallets.map(&:currency).uniq
    if currencies.size > 1
      errors.add(:base, "All wallets must use the same currency")
    end
  end
  
  def validate_transaction_limits
    if amount_cents > 1_000_000_00 # $1,000,000
      errors.add(:amount, "exceeds maximum transaction limit")
    end
  end
  
  def validate_business_hours
    return if self.class.skip_business_hours_validation
    
    current_time = Time.current
    unless current_time.on_weekday? && current_time.hour.between?(9, 17)
      errors.add(:base, "transactions only allowed during business hours")
    end
  end
  
  def update_wallet_balances
    source_wallet&.calculate_balance
    target_wallet&.calculate_balance
  end
  
  def log_transaction_creation
    Rails.logger.info("Transaction #{id} created: #{transaction_type} - #{amount_cents} #{currency}")
  end
  
  def log_status_change
    Rails.logger.info("Transaction #{id} status changed from #{status_before_last_save} to #{status}")
  end
end

class TransferTransaction < Transaction
  before_create :set_type_transfer
  validates :source_wallet, :target_wallet, presence: true
  
  private
  
  def set_type_transfer
    self.transaction_type = :transfer
  end
end

class DepositTransaction < Transaction
  before_create :set_type_deposit
  validates :target_wallet, presence: true
  validates :source_wallet, absence: true
  
  private
  
  def set_type_deposit
    self.transaction_type = :deposit
  end
end

class WithdrawalTransaction < Transaction
  before_create :set_type_withdrawal
  validates :source_wallet, presence: true
  validates :target_wallet, absence: true
  
  private
  
  def set_type_withdrawal
    self.transaction_type = :withdrawal
  end
end
