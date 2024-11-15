require 'rails_helper'

RSpec.describe 'Api::V1::Stocks', type: :request do
  let(:user) { create(:user) }
  before { sign_in(user) }

  describe 'GET /api/v1/stocks/price' do
    it 'returns stock price' do
      VCR.use_cassette('stock_price_single') do
        get '/api/v1/stocks/price', params: { symbol: 'AAPL' }

        expect(response).to have_http_status(:success)
        expect(json_response['symbol']).to eq('AAPL')
        expect(json_response['price']).to be_present
      end
    end
  end

  describe 'GET /api/v1/stocks/prices' do
    it 'returns multiple stock prices' do
      VCR.use_cassette('stock_prices_multiple') do
        get '/api/v1/stocks/prices', params: { symbols: ['AAPL', 'GOOGL'] }

        expect(response).to have_http_status(:success)
        expect(json_response['prices'].length).to eq(2)
      end
    end
  end
end