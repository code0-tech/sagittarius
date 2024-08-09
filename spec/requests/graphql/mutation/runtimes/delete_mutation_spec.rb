# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'runtimesDelete Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: RuntimesDeleteInput!) {
        runtimesDelete(input: $input) {
          #{error_query}
          runtime {
            id
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
  let(:current_user) { create(:user) }

  context 'when user is valid and is admin' do
    let(:current_user) { create(:user, :admin) }

    it 'deletes runtime' do
      mutate!

      expect(graphql_data_at(:runtimes_delete, :runtime, :id)).to be_present

      expect(
        SagittariusSchema.object_from_id(
          graphql_data_at(:runtimes_delete, :runtime, :id)
        )
      ).to be_nil

      is_expected.to create_audit_event(
        :runtime_deleted,
        author_id: current_user.id,
        entity_id: runtime.id,
        entity_type: 'Runtime',
        details: {},
        target_id: 0,
        target_type: 'global'
      )
    end
  end

  context 'when user is valid and namespace is given' do
    let(:namespace) do
      create(:namespace).tap do |namespace|
        create(:namespace_member, namespace: namespace, user: current_user)
      end
    end
    let(:runtime) do
      create(:runtime, namespace: namespace)
    end

    before do
      stub_allowed_ability(NamespacePolicy, :delete_runtime, user: current_user, subject: runtime.namespace)
    end

    it 'deletes runtime' do
      mutate!
      expect(graphql_data_at(:runtimes_delete, :runtime, :id)).to be_present

      expect(
        SagittariusSchema.object_from_id(
          graphql_data_at(:runtimes_delete, :runtime, :id)
        )
      ).to be_nil

      is_expected.to create_audit_event(
        :runtime_deleted,
        author_id: current_user.id,
        entity_id: runtime.id,
        entity_type: 'Runtime',
        details: {},
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end
  end
end
