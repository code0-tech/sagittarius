# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['NamespaceProject'] do
  let(:fields) do
    %w[
      id
      name
      description
      namespace
      primary_runtime
      runtimes
      roles
      flows
      flow
      user_abilities
      created_at
      updated_at
    ]
  end

  it { expect(described_class.graphql_name).to eq('NamespaceProject') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_namespace_project) }
end
