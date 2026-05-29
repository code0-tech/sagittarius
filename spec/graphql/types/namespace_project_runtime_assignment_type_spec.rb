# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['NamespaceProjectRuntimeAssignment'] do
  let(:fields) do
    %w[
      id
      compatible
      moduleConfigurations
      runtime
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('NamespaceProjectRuntimeAssignment') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_namespace_project_runtime_assignment) }
end
