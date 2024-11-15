module AuthHelper
    def auth_headers(user = nil)
      user ||= create(:user)
      token = AuthTokenService.encode(user_id: user.id)
      { 'Authorization': "Bearer #{token}" }
    end
end

  RSpec.configure do |config|
    config.include AuthHelper, type: :request
  end
