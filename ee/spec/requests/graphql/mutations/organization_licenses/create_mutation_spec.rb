# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizationLicensesCreate Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: OrganizationLicensesCreateInput!) {
        organizationLicensesCreate(input: $input) {
          #{error_query}
          organizationLicense {
            id
            organization {
              id
            }
          }
        }
      }
    QUERY
  end

  let(:organization) { create(:organization) }
  let(:input) do
    data = create(:organization_license).data

    {
      organizationId: organization.to_global_id.to_s,
      data: data,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is a member of the organization' do
    before do
      create(:organization_member, organization: organization, user: current_user)
      stub_allowed_ability(OrganizationPolicy, :create_organization_license, user: current_user, subject: organization)
      stub_allowed_ability(OrganizationPolicy, :read_organization_license, user: current_user, subject: organization)
    end

    it 'creates organization license' do
      mutate!

      expect(graphql_data_at(:organization_licenses_create, :organization_license, :id)).to be_present

      organization_license = SagittariusSchema.object_from_id(
        graphql_data_at(:organization_licenses_create, :organization_license, :id)
      )

      expect(organization_license.organization).to eq(organization)

      is_expected.to create_audit_event(
        :organization_license_created,
        author_id: current_user.id,
        entity_id: organization_license.id,
        entity_type: 'OrganizationLicense',
        target_id: organization.id,
        target_type: 'Organization'
      )
    end

    context 'when license is invalid' do
      let(:input) { { organizationId: organization.to_global_id.to_s, data: 'invalid license' } }

      it 'returns an error' do
        mutate!

        expect(graphql_data_at(:organization_licenses_create, :organization_license)).to be_nil
        expect(
          graphql_data_at(:organization_licenses_create, :errors)
        ).to include({ 'attribute' => 'data', 'type' => 'invalid' })
      end
    end
  end

  context 'when user is not a member of the organization' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:organization_licenses_create, :organization_license)).to be_nil
      expect(graphql_data_at(:organization_licenses_create, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
