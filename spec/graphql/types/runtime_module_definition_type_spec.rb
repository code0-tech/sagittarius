# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['RuntimeModuleDefinition'] do
  let(:fields) do
    %w[
      id
      host
      port
      endpoint
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('RuntimeModuleDefinition') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_runtime_module) }
end
