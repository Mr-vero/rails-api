require 'rails_helper'

RSpec.describe 'Api::V1::Wallets', type: :request do
  let(:user) { create(:user) }
  let(:wallet) { user.wallet }
  let(:headers) { auth_headers(user) }

  describe 'GET /api/v1/wallets/:id' do
    it 'returns wallet details' do
      get "/api/v1/wallets/#{wallet.id}", headers: headers

      expect(response).to have_http_status(:success)
      expect(json_response['data']['id']).to eq(wallet.id)
      expect(json_response['data']['balance']['amount']).to eq(wallet.balance.to_f)
    end
  end

  describe 'GET /api/v1/wallets/:id/balance' do
    it 'returns wallet balance' do
      get "/api/v1/wallets/#{wallet.id}/balance", headers: headers

      expect(response).to have_http_status(:success)
      expect(json_response['data']['balance']['amount']).to eq(wallet.balance.to_f)
      expect(json_response['data']['balance']['currency']).to eq(wallet.currency)
    end
  end
end