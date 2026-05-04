# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['UserOrganizationPin'] do
  let(:fields) do
    %w[
      id
      user
      organization
      priority
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('UserOrganizationPin') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_user_organization_pin) }
end
