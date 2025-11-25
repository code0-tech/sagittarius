# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'application Query' do
  include GraphqlHelpers

  let(:query) do
    <<~QUERY
      query {
        application {
          settings {
            userRegistrationEnabled
            organizationCreationRestricted
          }
          metadata {
            version
            extensions
          }
        }
      }
    QUERY
  end

  let(:current_user) { nil }

  before do
    post_graphql(query, current_user: current_user)
  end

  context 'when querying application settings' do
    let(:current_user) { create(:user, :admin) }

    it 'returns the application settings' do
      settings = graphql_data_at(:application, :settings)

      expect(settings['userRegistrationEnabled'])
        .to eq(ApplicationSetting.current['user_registration_enabled'])
      expect(settings['organizationCreationRestricted'])
        .to eq(ApplicationSetting.current['organization_creation_restricted'])
    end
  end

  it 'returns null application settings because of permissions' do
    settings = graphql_data_at(:application, :settings)
    expect(settings).to be_nil
  end

  it 'returns the application version' do
    expect(graphql_data_at(:application, :metadata, :version)).to eq(Sagittarius::Version)
  end

  it 'returns the list of active extensions' do
    expected_extensions = Sagittarius::Extensions.active.map(&:to_s)
    expect(graphql_data_at(:application, :metadata, :extensions)).to match_array(expected_extensions)
  end

  it 'does not require authentication' do
    expect(graphql_errors).to be_nil
  end
end
