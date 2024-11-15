require 'rails_helper'

RSpec.describe 'Api::V1::Sessions', type: :request do
  let(:user) { create(:user, password: 'password123') }

  describe 'POST /api/v1/session' do
    context 'with valid credentials' do
      it 'returns success and authentication token' do
        post '/api/v1/session', params: {
          email: user.email,
          password: 'password123'
        }

        expect(response).to have_http_status(:success)
        expect(json_response['token']).to be_present
        expect(json_response['user']['id']).to eq(user.id)
        expect(json_response['user']['email']).to eq(user.email)
        expect(json_response['user']).not_to include('password_digest')
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized status' do
        post '/api/v1/session', params: {
          email: user.email,
          password: 'wrong_password'
        }

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq('Invalid credentials')
      end
    end
  end

  describe 'DELETE /api/v1/session' do
    it 'returns success' do
      delete '/api/v1/session', headers: auth_headers(user)
      expect(response).to have_http_status(:no_content)
    end
  end
end