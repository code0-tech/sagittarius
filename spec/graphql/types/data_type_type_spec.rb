# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['DataType'] do
  let(:fields) do
    %w[
      namespace
      identifier
      variant
      id
      rules
      name
      parent
      genericKeys
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('DataType') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
