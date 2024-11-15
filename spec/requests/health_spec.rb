require 'rails_helper'

RSpec.describe "Health Check", type: :request do
  describe "GET /api/v1/health" do
    it "returns health status" do
      get "/api/v1/health"
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("ok")
    end
  end
end