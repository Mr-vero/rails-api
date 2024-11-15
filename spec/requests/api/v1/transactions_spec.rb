require 'rails_helper'

RSpec.describe 'Api::V1::Transactions', type: :request do
  let(:user) { create(:user) }
  let(:wallet) { user.wallet }
  let(:headers) { auth_headers(user) }

  describe 'GET /api/v1/transactions' do
    before do
      create_list(:deposit_transaction, 3, target_wallet: wallet)
    end

    it 'returns transaction history' do
      get '/api/v1/transactions', headers: headers
      expect(response).to have_http_status(:success)
      expect(json_response['data']['transactions'].length).to eq(3)
    end
  end
end