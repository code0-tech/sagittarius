# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Error'] do
  it 'returns possible types' do
    expect(described_class.possible_types).to include(
      Types::Errors::ActiveModelErrorType,
      Types::Errors::MessageErrorType
    )
  end

  describe '.resolve_type' do
    it 'resolves active model errors' do
      expect(
        described_class.resolve_type(ActiveModel::Error.new(nil, :test, :invalid), {})
      ).to eq(Types::Errors::ActiveModelErrorType)
    end

    it 'resolves message errors' do
      expect(
        described_class.resolve_type(Sagittarius::Graphql::ErrorMessageContainer.new(message: 'message'), {})
      ).to eq(Types::Errors::MessageErrorType)
    end

    it 'raises an error for invalid types' do
      expect { described_class.resolve_type(build(:user), {}) }.to raise_error 'Unsupported ErrorType'
    end
  end
end
