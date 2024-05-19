# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Organization'] do
  let(:fields) do
    %w[
      id
      name
      members
      roles
      projects
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('Organization') }
  it { expect(described_class).to have_graphql_fields(fields).allow_unexpected_if_extended }
  it { expect(described_class).to require_graphql_authorizations(:read_organization) }

  context 'when requesting members' do
    it_behaves_like 'prevents N+1 queries (graphql)' do
      let(:query) do
        <<~QUERY
          query($organizationId: OrganizationID) {
            organization(id: $organizationId) {
              members {
                count
                nodes {
                  id
                  user { username }
                  organization { name }
                }
              }
            }
          }
        QUERY
      end

      let(:current_user) { create(:user) }
      let(:organization) do
        create(:organization).tap do |organization|
          create(:organization_member, organization: organization, user: current_user)
        end
      end
      let(:variables) { { organizationId: organization.to_global_id.to_s } }

      let(:create_new_record) do
        -> { create(:organization_member, organization: organization) }
      end
    end
  end

  context 'when requesting roles' do
    it_behaves_like 'prevents N+1 queries (graphql)' do
      let(:query) do
        <<~QUERY
          query($organizationId: OrganizationID) {
            organization(id: $organizationId) {
              roles {
                count
                nodes {
                  id
                  name
                  organization { name }
                }
              }
            }
          }
        QUERY
      end

      let(:current_user) { create(:user) }
      let(:organization) do
        create(:organization).tap do |organization|
          create(:organization_member, organization: organization, user: current_user)
          create(:organization_role, organization: organization)
        end
      end
      let(:variables) { { organizationId: organization.to_global_id.to_s } }

      let(:create_new_record) do
        -> { create(:organization_role, organization: organization) }
      end
    end
  end
end
