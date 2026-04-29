# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'licensesCreate Mutation', unless: Sagittarius::Extensions.cloud? do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: LicensesCreateInput!) {
        licensesCreate(input: $input) {
          #{error_query}
          license {
            id
          }
        }
      }
    QUERY
  end

  let(:input) do
    {
      data: create(:license).data,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is a admin' do
    let(:current_user) { create(:user, :admin) }

    it 'creates license' do
      mutate!

      expect(graphql_data_at(:licenses_create, :license, :id)).to be_present

      license = SagittariusSchema.object_from_id(
        graphql_data_at(:licenses_create, :license, :id)
      )

      is_expected.to create_audit_event(
        :license_created,
        author_id: current_user.id,
        entity_id: license.id,
        entity_type: 'License',
        target_id: 0,
        target_type: 'global'
      )
    end

    context 'when license is invalid' do
      let(:input) { { data: 'invalid license' } }

      it 'returns an error' do
        mutate!

        expect(graphql_data_at(:licenses_create, :license)).to be_nil
        expect(
          graphql_data_at(:licenses_create, :errors, :details)
        ).to include([{ 'attribute' => 'data', 'type' => 'invalid' }])
      end
    end
  end

  context 'when user is not an admin' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:licenses_create, :license)).to be_nil
      expect(graphql_data_at(:licenses_create, :errors, :error_code)).to include('MISSING_PERMISSION')
    end
  end
end
