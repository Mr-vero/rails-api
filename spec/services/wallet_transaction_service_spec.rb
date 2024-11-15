require 'rails_helper'

RSpec.describe WalletTransactionService do
  let(:service) { described_class }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:wallet1) { user1.wallet }
  let(:wallet2) { user2.wallet }

  describe '.transfer' do
    before do
      # Add initial funds to source wallet
      service.deposit(
        wallet: wallet1,
        amount: Money.new(2000, 'USD'),
        description: "Initial deposit"
      )
    end

    it 'creates a valid transfer between wallets' do
      amount = Money.new(1000, 'USD')
      
      expect {
        service.transfer(
          source_wallet: wallet1,
          target_wallet: wallet2,
          amount: amount,
          description: "Test transfer"
        )
      }.to change(Transaction, :count).by(1)
      
      wallet1.reload
      wallet2.reload
      
      expect(wallet1.balance_cents).to eq(1000)
      expect(wallet2.balance_cents).to eq(1000)
    end
  end

  describe '.deposit' do
    it 'creates a valid deposit transaction' do
      amount = Money.new(1000, 'USD')
      
      expect {
        service.deposit(
          wallet: wallet1,
          amount: amount,
          description: "Test deposit"
        )
      }.to change(Transaction, :count).by(1)
      
      wallet1.reload
      expect(wallet1.balance_cents).to eq(1000)
    end
  end
end