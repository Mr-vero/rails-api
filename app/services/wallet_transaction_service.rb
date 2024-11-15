# Handles all wallet transaction operations with proper validations and ACID compliance
#
# @example Transfer money between wallets
#   WalletTransactionService.transfer(
#     source_wallet: user.wallet,
#     target_wallet: team.wallet,
#     amount: Money.new(1000, 'USD'),
#     description: "Team contribution"
#   )
class WalletTransactionService
  class InsufficientFundsError < StandardError; end
  class InvalidAmountError < StandardError; end
  class InvalidCurrencyError < StandardError; end

  def self.transfer(source_wallet:, target_wallet:, amount:, description:)
    new.transfer(
      source_wallet: source_wallet,
      target_wallet: target_wallet,
      amount: amount,
      description: description
    )
  end

  def self.deposit(wallet:, amount:, description:)
    new.deposit(
      wallet: wallet,
      amount: amount,
      description: description
    )
  end

  def self.withdraw(wallet:, amount:, description:)
    new.withdraw(
      wallet: wallet,
      amount: amount,
      description: description
    )
  end

  def transfer(source_wallet:, target_wallet:, amount:, description:)
    validate_amount!(amount)
    validate_sufficient_funds!(source_wallet, amount)
    validate_matching_currencies!(source_wallet, target_wallet)

    ActiveRecord::Base.transaction do
      transaction = Transaction.create!(
        source_wallet: source_wallet,
        target_wallet: target_wallet,
        amount_cents: amount.cents,
        currency: amount.currency.iso_code,
        description: description,
        transaction_type: :transfer,
        status: :pending
      )

      begin
        # Process transfer logic here
        # You could add additional checks or external service calls
        
        transaction.completed!
        true
      rescue StandardError => e
        transaction.failed!
        raise ActiveRecord::Rollback
      end
    end
  end

  def deposit(wallet:, amount:, description:)
    validate_amount!(amount)

    ActiveRecord::Base.transaction do
      transaction = Transaction.create!(
        target_wallet: wallet,
        amount_cents: amount.cents,
        currency: amount.currency.iso_code,
        description: description,
        transaction_type: :deposit,
        status: :pending
      )

      begin
        transaction.completed!
        true
      rescue StandardError => e
        transaction.failed!
        raise ActiveRecord::Rollback
      end
    end
  end

  def withdraw(wallet:, amount:, description:)
    validate_amount!(amount)
    validate_sufficient_funds!(wallet, amount)

    ActiveRecord::Base.transaction do
      transaction = Transaction.create!(
        source_wallet: wallet,
        amount_cents: amount.cents,
        currency: amount.currency.iso_code,
        description: description,
        transaction_type: :withdrawal,
        status: :pending
      )

      begin
        transaction.completed!
        true
      rescue StandardError => e
        transaction.failed!
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def validate_amount!(amount)
    raise InvalidAmountError, "Amount must be greater than 0" if amount <= 0
  end

  def validate_sufficient_funds!(wallet, amount)
    raise InsufficientFundsError, "Insufficient funds in the source wallet" if wallet.balance_cents < amount.cents
  end

  def validate_matching_currencies!(source_wallet, target_wallet)
    raise InvalidCurrencyError, "All wallets must use the same currency" if source_wallet.currency != target_wallet.currency
  end
end