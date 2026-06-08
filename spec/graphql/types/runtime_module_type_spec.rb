# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['RuntimeModule'] do
  let(:fields) do
    %w[
      id
      identifier
      names
      descriptions
      documentation
      author
      icon
      version
      definitions
      runtime
      dataTypes
      runtimeFlowTypes
      flowTypes
      runtimeFunctionDefinitions
      functionDefinitions
      configurationDefinitions
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('RuntimeModule') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_runtime_module) }
end
