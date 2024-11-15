require 'rails_helper'

RSpec.describe 'Api::V1::Wallets', type: :request do
  let(:user) { create(:user) }
  let(:wallet) { user.wallet }

  before { sign_in(user) }

  describe 'GET /api/v1/wallets/:id' do
    it 'returns wallet details' do
      get "/api/v1/wallets/#{wallet.id}"

      expect(response).to have_http_status(:success)
      expect(json_response['balance_cents']).to eq(wallet.balance_cents)
      expect(json_response['currency']).to eq(wallet.currency)
    end
  end

  describe 'GET /api/v1/wallets/:id/balance' do
    it 'returns wallet balance' do
      get "/api/v1/wallets/#{wallet.id}/balance"

      expect(response).to have_http_status(:success)
      expect(json_response['balance']['amount']).to eq(wallet.balance.to_f)
      expect(json_response['balance']['currency']).to eq(wallet.currency)
    end
  end
end