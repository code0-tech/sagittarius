# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['NamespaceMember'] do
  let(:fields) do
    %w[
      id
      user
      namespace
      memberRoles
      roles
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('NamespaceMember') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_namespace_member) }
end
