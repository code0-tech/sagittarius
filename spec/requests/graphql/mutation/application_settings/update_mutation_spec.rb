# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'applicationSettingsUpdate Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: ApplicationSettingsUpdateInput!) {
        applicationSettingsUpdate(input: $input) {
          #{error_query}
          applicationSettings {
            userRegistrationEnabled
            organizationCreationRestricted
            identityProviders {
              nodes {
                type
                id
              }
            }
          }
        }
      }
    QUERY
  end

  let(:input) { { userRegistrationEnabled: false } }

  let(:variables) { { input: input } }
  let(:current_user) { create(:user, :admin) }

  before { post_graphql mutation, variables: variables, current_user: current_user }

  it 'updates application settings' do
    expect(graphql_data_at(:application_settings_update, :application_settings)).to be_present
    expect(graphql_data_at(:application_settings_update, :application_settings, :user_registration_enabled)).to be false

    is_expected.to create_audit_event(
      :application_setting_updated,
      author_id: current_user.id,
      entity_type: 'ApplicationSetting',
      details: { setting: 'user_registration_enabled', value: false },
      target_type: 'ApplicationSetting'
    )
  end

  context 'when user is not an admin' do
    let(:current_user) { create(:user) }

    it 'returns an error' do
      expect(graphql_data_at(:application_settings_update, :application_settings)).to be_nil
      expect(graphql_data_at(:application_settings_update, :errors, :error_code)).to include('MISSING_PERMISSION')
    end
  end
end
