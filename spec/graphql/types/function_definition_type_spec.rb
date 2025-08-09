# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['FunctionDefinition'] do
  let(:fields) do
    %w[
      id
      returnType
      parameterDefinitions
      names
      descriptions
      documentations
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('FunctionDefinition') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_function_definition) }
end
