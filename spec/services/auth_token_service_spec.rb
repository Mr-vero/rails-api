require 'rails_helper'

RSpec.describe AuthTokenService do
  let(:user) { create(:user) }
  let(:payload) { { user_id: user.id } }

  describe '.encode' do
    it 'generates a valid token' do
      token = described_class.encode(payload)
      expect(token).to include(':')
      parts = token.split(':')
      expect(parts.length).to eq(3)
      expect(parts[0].to_i).to eq(user.id)
    end
  end

  describe '.decode' do
    it 'decodes a valid token' do
      token = described_class.encode(payload)
      decoded = described_class.decode(token)
      expect(decoded[:user_id]).to eq(user.id)
    end

    it 'returns nil for invalid token' do
      expect(described_class.decode('invalid')).to be_nil
    end

    it 'returns nil for expired token' do
      travel_to 25.hours.from_now do
        token = described_class.encode(payload)
        expect(described_class.decode(token)).to be_nil
      end
    end
  end
end
