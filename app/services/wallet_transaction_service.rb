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
      transaction = TransferTransaction.create!(
        source_wallet: source_wallet,
        target_wallet: target_wallet,
        amount_cents: amount.cents,
        currency: amount.currency.iso_code,
        description: description,
        status: :pending
      )

      begin
        transaction.completed!
        source_wallet.calculate_balance
        target_wallet.calculate_balance
        Result.success(transaction)
      rescue StandardError => e
        transaction.failed!
        Result.error("Transfer failed: #{e.message}")
      end
    end
  rescue StandardError => e
    Result.error(e.message)
  end

  def deposit(wallet:, amount:, description:)
    validate_amount!(amount)

    Transaction.skip_business_rules = true
    begin
      ActiveRecord::Base.transaction do
        transaction = DepositTransaction.new(
          target_wallet: wallet,
          amount_cents: amount.cents,
          currency: amount.currency.iso_code,
          description: description,
          status: :pending
        )

        transaction.save!

        begin
          transaction.completed!
          wallet.calculate_balance
          Result.success(transaction)
        rescue StandardError => e
          transaction.failed!
          Result.error("Deposit failed: #{e.message}")
        end
      end
    ensure
      Transaction.skip_business_rules = false
    end
  rescue StandardError => e
    Result.error(e.message)
  end

  def withdraw(wallet:, amount:, description:)
    validate_amount!(amount)
    validate_sufficient_funds!(wallet, amount)

    Transaction.skip_business_rules = true
    begin
      ActiveRecord::Base.transaction do
        transaction = WithdrawalTransaction.new(
          source_wallet: wallet,
          amount_cents: amount.cents,
          currency: amount.currency.iso_code,
          description: description,
          status: :pending
        )

        transaction.save!

        begin
          transaction.completed!
          wallet.calculate_balance
          Result.success(transaction)
        rescue StandardError => e
          transaction.failed!
          Result.error("Withdrawal failed: #{e.message}")
        end
      end
    ensure
      Transaction.skip_business_rules = false
    end
  rescue StandardError => e
    Result.error(e.message)
  end

  private

  def validate_amount!(amount)
    raise InvalidAmountError, "Amount must be greater than 0" unless amount.positive?
    raise InvalidAmountError, "Amount exceeds maximum limit" if amount.cents > 1_000_000_00
  end

  def validate_sufficient_funds!(wallet, amount)
    raise InsufficientFundsError, "Insufficient funds" if wallet.balance < amount
  end

  def validate_matching_currencies!(source_wallet, target_wallet)
    raise InvalidCurrencyError, "Currency mismatch" if source_wallet.currency != target_wallet.currency
  end
end
