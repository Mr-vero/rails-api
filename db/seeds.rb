# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
puts "Cleaning database..."
[ User, Team, Stock, Wallet, Transaction, ExchangeRate ].each(&:delete_all)

# Temporarily disable business hours validation
Transaction.skip_business_hours_validation = true

begin
  # Create Users
  puts "Creating users..."
  users = [
    { email: 'john@example.com', password: 'password123' },
    { email: 'jane@example.com', password: 'password123' },
    { email: 'admin@example.com', password: 'password123' }
  ].map { |attrs| User.create!(attrs) }

  # Create Teams
  puts "Creating teams..."
  teams = [
    { name: 'Engineering' },
    { name: 'Marketing' },
    { name: 'Sales' }
  ].map { |attrs| Team.create!(attrs) }

  # Create Stocks
  puts "Creating stocks..."
  stocks = [
    { symbol: 'AAPL' },
    { symbol: 'GOOGL' },
    { symbol: 'MSFT' }
  ].map { |attrs| Stock.create!(attrs) }

  # Create Exchange Rates
  puts "Creating exchange rates..."
  exchange_rates = [
    { source_currency: 'USD', target_currency: 'EUR', rate: 0.85 },
    { source_currency: 'USD', target_currency: 'GBP', rate: 0.73 },
    { source_currency: 'EUR', target_currency: 'GBP', rate: 0.86 }
  ].map { |attrs| ExchangeRate.create!(attrs) }

  # Create Initial Transactions
  puts "Creating initial transactions..."

  # Deposit to user wallets
  users.each do |user|
    WalletTransactionService.deposit(
      wallet: user.wallet,
      amount: Money.new(100000, 'USD'), # $1,000.00
      description: "Initial deposit for #{user.email}"
    )
  end

  # Deposit to team wallets
  teams.each do |team|
    WalletTransactionService.deposit(
      wallet: team.wallet,
      amount: Money.new(1000000, 'USD'), # $10,000.00
      description: "Initial deposit for #{team.name} team"
    )
  end

  # Deposit to stock wallets
  stocks.each do |stock|
    WalletTransactionService.deposit(
      wallet: stock.wallet,
      amount: Money.new(5000000, 'USD'), # $50,000.00
      description: "Initial deposit for #{stock.symbol} stock"
    )
  end

  # Create some transfers between wallets
  puts "Creating transfers..."

  # Transfer between users
  WalletTransactionService.transfer(
    source_wallet: users[0].wallet,
    target_wallet: users[1].wallet,
    amount: Money.new(25000, 'USD'), # $250.00
    description: "Test transfer between users"
  )

  # Transfer from team to user
  WalletTransactionService.transfer(
    source_wallet: teams[0].wallet,
    target_wallet: users[0].wallet,
    amount: Money.new(50000, 'USD'), # $500.00
    description: "Bonus payment"
  )

  puts "\nSeed data created successfully!"
  puts "\nTest user credentials:"
  puts "Email: john@example.com"
  puts "Password: password123"
ensure
  # Re-enable business hours validation
  Transaction.skip_business_hours_validation = false
end
