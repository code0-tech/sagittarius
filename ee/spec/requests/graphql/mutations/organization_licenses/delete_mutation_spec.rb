# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizationLicensesDelete Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: OrganizationLicensesDeleteInput!) {
        organizationLicensesDelete(input: $input) {
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
  let(:license) { create(:organization_license, organization: organization) }
  let(:input) do
    {
      organizationId: organization.to_global_id.to_s,
      organizationLicenseId: license.to_global_id.to_s,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is a member of the organization' do
    before do
      create(:organization_member, organization: organization, user: current_user)
      stub_allowed_ability(OrganizationPolicy, :delete_organization_license, user: current_user, subject: organization)
      stub_allowed_ability(OrganizationPolicy, :read_organization_license, user: current_user, subject: organization)
    end

    it 'deletes organization license' do
      mutate!

      expect(graphql_data_at(:organization_licenses_delete, :organization_license, :id)).to be_present

      organization_license = SagittariusSchema.object_from_id(
        graphql_data_at(:organization_licenses_delete, :organization_license, :id)
      )

      expect(organization_license).to be_nil

      is_expected.to create_audit_event(
        :organization_license_deleted,
        author_id: current_user.id,
        entity_id: license.id,
        entity_type: 'OrganizationLicense',
        target_id: organization.id,
        target_type: 'Organization'
      )
    end
  end

  context 'when user is not a member of the organization' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:organization_licenses_delete, :organization_license)).to be_nil
      expect(graphql_data_at(:organization_licenses_delete, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
