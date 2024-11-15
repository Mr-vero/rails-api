class AuthTokenService
  class << self
    def encode(payload)
      expiration = 24.hours.from_now.to_i
      message = "#{payload[:user_id]}:#{expiration}"
      signature = generate_signature(message)
      "#{message}:#{signature}"
    end

    def decode(token)
      user_id, expiration, signature = token.to_s.split(':')
      
      return nil unless valid_token?(user_id, expiration, signature)
      return nil if expired?(expiration)
      
      { user_id: user_id.to_i }
    end

    private

    def generate_signature(message)
      OpenSSL::HMAC.hexdigest(
        'SHA256',
        Rails.application.credentials.secret_key_base,
        message
      )
    end

    def valid_token?(user_id, expiration, signature)
      return false unless user_id && expiration && signature
      expected_signature = generate_signature("#{user_id}:#{expiration}")
      ActiveSupport::SecurityUtils.secure_compare(expected_signature, signature)
    end

    def expired?(expiration)
      expiration.to_i < Time.current.to_i
    end
  end
end