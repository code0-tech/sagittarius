# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['ParameterDefinition'] do
  let(:fields) do
    %w[
      id
      dataType
      descriptions
      names
      documentations
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('ParameterDefinition') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_parameter_definition) }
end
