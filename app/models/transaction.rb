# Represents a financial transaction between wallets
#
# @example Create a transfer transaction
#   TransferTransaction.create(
#     source_wallet: user.wallet,
#     target_wallet: team.wallet,
#     amount_cents: 1000,
#     currency: 'USD',
#     description: 'Team contribution'
#   )
class Transaction < ApplicationRecord
  include BusinessRules

  belongs_to :source_wallet, class_name: "Wallet", optional: true
  belongs_to :target_wallet, class_name: "Wallet", optional: true

  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :description, presence: true

  enum status: { pending: 0, completed: 1, failed: 2 }
  enum transaction_type: { transfer: 0, deposit: 1, withdrawal: 2 }

  # remove for now
  # before_validation :validate_business_hours, on: :create
  before_validation :validate_wallets

  after_create :log_transaction_creation
  after_save :log_status_change, if: :saved_change_to_status?
  after_save :update_wallet_balances, if: -> { completed? && saved_change_to_status? }

  class << self
    attr_accessor :skip_business_hours_validation
  end

  private

  def validate_business_hours
    return if self.class.skip_business_hours_validation

    current_time = Time.current
    unless current_time.on_weekday? && current_time.hour.between?(9, 17)
      errors.add(:base, "transactions only allowed during business hours")
    end
  end

  def validate_wallets
    return if self.class.skip_business_rules

    case transaction_type&.to_sym
    when :transfer
      unless source_wallet && target_wallet
        errors.add(:base, "Transfer requires both source and target wallets")
      end
    when :deposit
      if target_wallet.blank?
        errors.add(:base, "Deposit requires a target wallet")
      end
    when :withdrawal
      if source_wallet.blank?
        errors.add(:base, "Withdrawal requires a source wallet")
      end
    end
  end

  def validate_same_currency
    wallets = [ source_wallet, target_wallet ].compact
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
    self.transaction_type = "transfer"
  end
end

class DepositTransaction < Transaction
  before_create :set_type_deposit
  validates :target_wallet, presence: true
  validates :source_wallet, absence: true

  private

  def set_type_deposit
    self.transaction_type = "deposit"
  end
end

class WithdrawalTransaction < Transaction
  before_create :set_type_withdrawal
  validates :source_wallet, presence: true
  validates :target_wallet, absence: true

  private

  def set_type_withdrawal
    self.transaction_type = "withdrawal"
  end
end
