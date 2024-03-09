# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['OrganizationRole'] do
  let(:fields) do
    %w[
      id
      organization
      name
      abilities
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('OrganizationRole') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_organization_role) }
end
