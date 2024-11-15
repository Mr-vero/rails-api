require 'rails_helper'

RSpec.describe 'Api::V1::Stocks', type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }

  describe 'GET /api/v1/stocks/price' do
    context 'with valid symbol' do
      it 'returns stock price' do
        VCR.use_cassette('stock_price_single') do
          get '/api/v1/stocks/price', params: { symbol: 'AAPL' }, headers: headers

          expect(response).to have_http_status(:success)
          expect(json_response['data']['symbol']).to eq('AAPL')
          expect(json_response['data']['price']).to be_present
        end
      end
    end

    context 'with missing symbol' do
      it 'returns bad request error' do
        get '/api/v1/stocks/price', headers: headers

        expect(response).to have_http_status(:bad_request)
        expect(json_response['error']).to eq('Symbol parameter is required')
      end
    end
  end

  describe 'GET /api/v1/stocks/prices' do
    context 'with valid symbols' do
      it 'returns multiple stock prices' do
        VCR.use_cassette('stock_prices_multiple') do
          get '/api/v1/stocks/prices', params: { symbols: 'AAPL,GOOGL' }, headers: headers

          expect(response).to have_http_status(:success)
          expect(json_response['data'].length).to eq(2)
        end
      end
    end

    context 'with missing symbols' do
      it 'returns bad request error' do
        get '/api/v1/stocks/prices', headers: headers

        expect(response).to have_http_status(:bad_request)
        expect(json_response['error']).to eq('No symbols provided')
      end
    end
  end

  describe 'GET /api/v1/stocks/price_all' do
    it 'returns all available stock prices' do
      VCR.use_cassette('stock_prices_all') do
        get '/api/v1/stocks/price_all', headers: headers

        expect(response).to have_http_status(:success)
        expect(json_response['data']).to be_an(Array)
        expect(json_response['data'].first).to include('symbol', 'price')
      end
    end
  end
end
