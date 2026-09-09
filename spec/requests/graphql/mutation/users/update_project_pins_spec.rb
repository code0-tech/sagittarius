# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersUpdateProjectPins Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersUpdateProjectPinsInput!) {
        usersUpdateProjectPins(input: $input) {
          #{error_query}
          user {
            id
            projectPins
          }
        }
      }
    QUERY
  end

  let(:current_user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:organization_namespace) { organization.ensure_namespace }
  let(:project_one) { create(:namespace_project, namespace: organization_namespace) }
  let(:project_two) { create(:namespace_project, namespace: organization_namespace) }

  let(:input) do
    {
      projectIds: [project_one.to_global_id.to_s, project_two.to_global_id.to_s],
    }
  end
  let(:variables) { { input: input } }

  context 'when the user is a member of the project namespace' do
    before do
      create(:namespace_member, namespace: organization_namespace, user: current_user)
    end

    it 'updates project pins in the requested order' do
      mutate!

      expect(graphql_data_at(:users_update_project_pins, :user, :id)).to eq(current_user.to_global_id.to_s)

      pins = graphql_data_at(:users_update_project_pins, :user, :project_pins)
      expect(pins).to eq(
        [project_one.to_global_id.to_s, project_two.to_global_id.to_s]
      )
    end
  end

  context 'when the user is not a member of the project namespace' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:users_update_project_pins, :user)).to be_nil
      expect(graphql_data_at(:users_update_project_pins, :errors, :error_code))
        .to include('PROJECT_NOT_FOUND')
    end
  end
end
