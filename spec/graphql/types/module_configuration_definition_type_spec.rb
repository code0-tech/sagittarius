# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['ModuleConfigurationDefinition'] do
  let(:fields) do
    %w[
      id
      identifier
      names
      descriptions
      type
      linkedDataTypes
      defaultValue
      optional
      hidden
      runtimeModule
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('ModuleConfigurationDefinition') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_module_configuration_definition) }
end
