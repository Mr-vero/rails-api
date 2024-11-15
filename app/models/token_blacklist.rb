class TokenBlacklist < ApplicationRecord
    validates :token, presence: true, uniqueness: true

    def self.revoked?(token)
      exists?(token: token)
    end
end
