module RequestHelpers
    def json_response
      @json_response ||= JSON.parse(response.body)
    end
  
    def sign_in(user)
      post '/api/v1/session', params: {
        email: user.email,
        password: 'password123'
      }
    end
  end
  
  RSpec.configure do |config|
    config.include RequestHelpers, type: :request
  end