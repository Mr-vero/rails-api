require 'rails_helper'

RSpec.describe Wallet, type: :model do
  let(:user) { create(:user) }
  let(:wallet) { user.wallet }

  describe 'associations' do
    it { should belong_to(:owner) }
    it { should have_many(:source_transactions) }
    it { should have_many(:target_transactions) }
  end

  describe 'validations' do
    it { should validate_presence_of(:balance_cents) }
    it { should validate_presence_of(:currency) }
  end

  describe '#calculate_balance' do
    it 'correctly calculates balance after transactions' do
      target_wallet = create(:user).wallet

      WalletTransactionService.deposit(
        wallet: wallet,
        amount: Money.new(1000, 'USD'),
        description: "Initial deposit"
      )
      WalletTransactionService.transfer(
        source_wallet: wallet,
        target_wallet: target_wallet,
        amount: Money.new(300, 'USD'),
        description: "Test transfer"
      )

      wallet.calculate_balance
      expect(wallet.balance_cents).to eq(700)
    end
  end
end
