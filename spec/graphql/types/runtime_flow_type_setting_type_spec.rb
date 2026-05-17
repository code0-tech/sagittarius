# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['RuntimeFlowTypeSetting'] do
  let(:fields) do
    %w[
      id
      identifier
      defaultValue
      optional
      hidden
      descriptions
      names
      removedAt
      runtimeFlowType
      unique
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('RuntimeFlowTypeSetting') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class.fields['unique'].type.to_type_signature).to eq('String!') }
  it { expect(described_class).to require_graphql_authorizations(:read_runtime_flow_type_setting) }
end
