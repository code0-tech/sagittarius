# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['DataType'] do
  let(:fields) do
    %w[
      identifier
      variant
      id
      rules
      name
      display_messages
      aliases
      runtime
      genericKeys
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('DataType') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
