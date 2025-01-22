# jwt helper test including:
# - encode
# - decode

require 'rails_helper'
require 'jwt'

RSpec.describe JwtHelper, type: :module do
  let(:payload) { { user_id: 1 } }
  let(:token) { JwtHelper.encode(payload) }

  describe '#decode' do
    context 'with a valid token' do
      it 'decodes the token and retrieves the payload' do
        decoded_payload = JwtHelper.decode(token)

        expect(decoded_payload['user_id']).to eq(payload[:user_id])
      end
    end

    context 'with an invalid token' do
      it 'returns nil for an invalid token' do
        invalid_token = 'invalid.token'

        expect(described_class.decode(invalid_token)).to be_nil
      end
    end
  end
end
