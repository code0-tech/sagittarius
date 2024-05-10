# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Organization'] do
  let(:fields) do
    %w[
      id
      name
      members
      roles
      createdAt
      updatedAt
      organizationLicenses
    ]
  end

  it { expect(described_class).to include_module(EE::Types::OrganizationType) }
  it { expect(described_class).to have_graphql_fields(fields) }
end
