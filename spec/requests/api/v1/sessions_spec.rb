require 'rails_helper'

RSpec.describe 'Api::V1::Sessions', type: :request do
  let(:user) { create(:user, password: 'password123') }

  describe 'POST /api/v1/session' do
    let(:valid_params) do
      {
        email: user.email,
        password: 'password123'
      }
    end

    context 'with valid credentials' do
      it 'returns success and user data' do
        post '/api/v1/session', params: valid_params

        expect(response).to have_http_status(:success)
        expect(json_response['token']).to be_present
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized status' do
        post '/api/v1/session', params: { email: user.email, password: 'wrong' }

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq('Invalid credentials')
      end
    end
  end
end