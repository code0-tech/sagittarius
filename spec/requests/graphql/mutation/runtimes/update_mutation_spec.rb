# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'runtimesUpdate Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: RuntimesUpdateInput!) {
        runtimesUpdate(input: $input) {
          #{error_query}
          runtime {
            id
            name
          }
        }
      }

    QUERY
  end

  let(:input) do
    name = generate(:runtime_name)

    {
      runtimeId: runtime.to_global_id.to_s,
      name: name,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user, :admin) }
  let(:runtime) do
    create(:runtime)
  end

  before do
    post_graphql mutation, variables: variables, current_user: current_user
  end

  it 'updates runtime' do
    expect(graphql_data_at(:runtimes_update, :runtime, :id)).to be_present

    runtime = SagittariusSchema.object_from_id(graphql_data_at(:runtimes_update, :runtime, :id))

    expect(runtime.name).to eq(input[:name])

    is_expected.to create_audit_event(
      :runtime_updated,
      author_id: current_user.id,
      entity_id: runtime.id,
      entity_type: 'Runtime',
      details: { name: input[:name] },
      target_id: 0,
      target_type: 'global'
    )
  end

  context 'when namespace is present' do
    let(:current_user) { create(:user) }
    let(:namespace) do
      create(:namespace).tap do |namespace|
        create(:namespace_member, namespace: namespace, user: current_user)
      end
    end
    let(:runtime) do
      create(:runtime, namespace: namespace)
    end

    before do
      stub_allowed_ability(NamespacePolicy, :update_runtime, user: current_user, subject: runtime.namespace)
      post_graphql mutation, variables: variables, current_user: current_user
    end

    it 'updates runtime' do
      expect(graphql_data_at(:runtimes_update, :runtime, :id)).to be_present

      runtime = SagittariusSchema.object_from_id(graphql_data_at(:runtimes_update, :runtime, :id))

      expect(runtime.name).to eq(input[:name])

      is_expected.to create_audit_event(
        :runtime_updated,
        author_id: current_user.id,
        entity_id: runtime.id,
        entity_type: 'Runtime',
        details: { name: input[:name] },
        target_id: runtime.namespace.id,
        target_type: 'Namespace'
      )
    end
  end

  context 'when organization name is taken' do
    let(:existing_runtime) { create(:runtime) }
    let(:input) do
      {
        runtimeId: runtime.to_global_id.to_s,
        name: existing_runtime.name,
      }
    end

    it 'returns an error' do
      expect(graphql_data_at(:runtimes_update, :organization)).to be_nil
      expect(graphql_data_at(:runtimes_update, :errors)).to include({ 'attribute' => 'name', 'type' => 'taken' })
    end
  end
end
