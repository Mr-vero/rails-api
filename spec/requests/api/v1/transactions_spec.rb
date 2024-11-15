require 'rails_helper'

RSpec.describe 'Api::V1::Transactions', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:wallet) { user.wallet }
  let(:other_wallet) { other_user.wallet }

  before { sign_in(user) }

  describe 'POST /api/v1/transactions' do
    context 'when creating a transfer' do
      let(:valid_params) do
        {
          type: 'transfer',
          amount: 100.00,
          currency: 'USD',
          target_wallet_id: other_wallet.id,
          description: 'Test transfer'
        }
      end

      it 'creates a successful transfer' do
        # First deposit money to source wallet
        post '/api/v1/transactions', params: {
          type: 'deposit',
          amount: 200.00,
          currency: 'USD',
          description: 'Initial deposit'
        }

        # Then make transfer
        post '/api/v1/transactions', params: valid_params

        expect(response).to have_http_status(:success)
        expect(json_response['message']).to eq('Transaction successful')
        
        # Verify balances
        wallet.reload
        other_wallet.reload
        expect(wallet.balance.to_f).to eq(100.00)
        expect(other_wallet.balance.to_f).to eq(100.00)
      end
    end

    context 'when creating a deposit' do
      let(:valid_params) do
        {
          type: 'deposit',
          amount: 100.00,
          currency: 'USD',
          description: 'Test deposit'
        }
      end

      it 'creates a successful deposit' do
        post '/api/v1/transactions', params: valid_params

        expect(response).to have_http_status(:success)
        expect(json_response['message']).to eq('Transaction successful')
        
        wallet.reload
        expect(wallet.balance.to_f).to eq(100.00)
      end
    end
  end

  describe 'GET /api/v1/transactions' do
    before do
      create_list(:transaction, 3, target_wallet: wallet)
    end

    it 'returns transaction history' do
      get '/api/v1/transactions'

      expect(response).to have_http_status(:success)
      expect(json_response['transactions'].length).to eq(3)
    end
  end
end