# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'licensesDelete Mutation', unless: Sagittarius::Extensions.cloud? do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: LicensesDeleteInput!) {
        licensesDelete(input: $input) {
          #{error_query}
          license {
            id
          }
        }
      }
    QUERY
  end

  let(:license) { create(:license) }
  let(:input) do
    {
      licenseId: license.to_global_id.to_s,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is admin' do
    let(:current_user) { create(:user, :admin) }

    it 'deletes license' do
      mutate!

      expect(graphql_data_at(:licenses_delete, :license, :id)).to be_present

      deleted_license = SagittariusSchema.object_from_id(
        graphql_data_at(:licenses_delete, :license, :id)
      )

      expect(deleted_license).to be_nil

      is_expected.to create_audit_event(
        :license_deleted,
        author_id: current_user.id,
        entity_id: license.id,
        entity_type: 'License',
        target_id: 0,
        target_type: 'global'
      )
    end
  end

  context 'when user is not an admin' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:licenses_delete, :license)).to be_nil
      expect(graphql_data_at(:licenses_delete, :errors, :error_code)).to include('MISSING_PERMISSION')
    end
  end
end
