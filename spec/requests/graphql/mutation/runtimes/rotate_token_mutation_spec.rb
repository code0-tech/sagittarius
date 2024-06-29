# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'runtimesRotate Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: RuntimesRotateTokenInput!) {
        runtimesRotateToken(input: $input) {
          #{error_query}
          runtime {
            id
            token
          }
        }
      }
    QUERY
  end

  let(:runtime) { create(:runtime) }

  let(:input) do
    {
      runtimeId: runtime.to_global_id.to_s,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user, admin: true) }

  context 'when rotating token' do
    it 'creates runtime' do
      mutate!
      expect(graphql_data_at(:runtimes_rotate_token, :runtime, :token)).to be_present
      expect(graphql_data_at(:runtimes_rotate_token, :runtime, :id)).to be_present

      runtime_from_db = SagittariusSchema.object_from_id(graphql_data_at(:runtimes_rotate_token, :runtime, :id))

      expect(graphql_data_at(:runtimes_rotate_token, :runtime, :token)).to eq(runtime_from_db.token)
      expect(runtime_from_db.token).not_to eq(runtime.token)

      is_expected.to create_audit_event(
        :runtime_token_rotated,
        author_id: current_user.id,
        entity_id: runtime.id,
        entity_type: 'Runtime',
        details: {},
        target_id: 0,
        target_type: 'global'
      )
    end
  end
end
