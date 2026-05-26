# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Authentication'] do
  it { expect(described_class).to include_module(CLOUD::Types::AuthenticationType) }

  it 'includes CraterTokenType as a possible type' do
    expect(described_class.possible_types).to include(Types::CraterTokenType)
  end

  describe '.resolve_type' do
    it 'resolves CraterLoginToken' do
      token = CLOUD::ApplicationController::CraterLoginToken.new(user: build(:user))
      expect(described_class.resolve_type(token, {})).to eq(Types::CraterTokenType)
    end
  end
end
