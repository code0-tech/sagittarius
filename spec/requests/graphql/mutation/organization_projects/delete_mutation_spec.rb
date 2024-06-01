# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizationProjectsDelete Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: OrganizationProjectsDeleteInput!) {
        organizationProjectsDelete(input: $input) {
          #{error_query}
          organizationProject {
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
  let(:organization_project) { create(:organization_project, organization: organization) }
  let(:input) do
    {
      organizationProjectId: organization_project.to_global_id.to_s,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is a member of the organization' do
    before do
      create(:organization_member, organization: organization, user: current_user)
      stub_allowed_ability(OrganizationProjectPolicy, :delete_organization_project, user: current_user,
                                                                                    subject: organization_project)
      stub_allowed_ability(OrganizationProjectPolicy, :read_organization_project, user: current_user,
                                                                                  subject: organization_project)
    end

    it 'deletes organization' do
      mutate!

      expect(graphql_data_at(:organization_projects_delete, :organization_project, :id)).to be_present

      expect(
        SagittariusSchema.object_from_id(
          graphql_data_at(:organization_projects_delete, :organization_project, :id)
        )
      ).to be_nil

      is_expected.to create_audit_event(
        :organization_project_deleted,
        author_id: current_user.id,
        entity_id: organization_project.id,
        entity_type: 'OrganizationProject',
        details: { organization_id: organization.id },
        target_id: organization_project.id,
        target_type: 'OrganizationProject'
      )
    end
  end

  context 'when user is not a member of the organization' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:organization_projects_delete, :organization_project)).to be_nil
      expect(graphql_data_at(:organization_projects_delete, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
