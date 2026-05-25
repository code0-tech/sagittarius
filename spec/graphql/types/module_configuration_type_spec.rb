# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['ModuleConfiguration'] do
  let(:fields) do
    %w[
      id
      definition
      value
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('ModuleConfiguration') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_module_configuration) }
end
