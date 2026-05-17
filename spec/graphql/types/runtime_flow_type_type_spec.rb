# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['RuntimeFlowType'] do
  let(:fields) do
    %w[
      id
      identifier
      editable
      signature
      displayIcon
      version
      definitionSource
      runtimeFlowTypeSettings
      names
      displayMessages
      aliases
      descriptions
      documentations
      runtime
      runtimeModule
      flowTypes
      linkedDataTypes
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('RuntimeFlowType') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_runtime_flow_type) }
end
