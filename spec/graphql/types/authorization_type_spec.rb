# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Authorization'] do
  it 'returns possible types' do
    expect(described_class.possible_types).to include(Types::UserSessionType)
  end

  describe '.resolve_type' do
    it 'resolves sessions' do
      expect(described_class.resolve_type(build(:user_session), {})).to eq(Types::UserSessionType)
    end

    it 'raises an error for invalid types' do
      expect { described_class.resolve_type(build(:user), {}) }.to raise_error 'Unsupported AuthorizationType'
    end
  end
end
