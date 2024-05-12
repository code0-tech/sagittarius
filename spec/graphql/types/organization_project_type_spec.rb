# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['OrganizationProject'] do
  let(:fields) do
    %w[
      id
      name
      description
      organization
      created_at
      updated_at
    ]
  end

  it { expect(described_class.graphql_name).to eq('OrganizationProject') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_organization_project) }
end
