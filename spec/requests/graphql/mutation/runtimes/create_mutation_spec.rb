# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'runtimesCreate Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: RuntimesCreateInput!) {
        runtimesCreate(input: $input) {
          #{error_query}
          runtime {
            id
            name
            token
            description
          }
        }
      }
    QUERY
  end

  let(:input) do
    name = generate(:runtime_name)

    {
      name: name,
      namespaceId: namespace.to_global_id.to_s,
    }
  end

  let(:namespace) { create(:namespace) }
  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  before do
    create(:namespace_member, user: current_user, namespace: namespace)
    stub_allowed_ability(NamespacePolicy, :create_runtime, subject: namespace, user: current_user)
    post_graphql mutation, variables: variables, current_user: current_user
  end

  it 'creates runtime' do
    expect(graphql_data_at(:runtimes_create, :runtime, :token)).to be_present
    expect(graphql_data_at(:runtimes_create, :runtime, :id)).to be_present

    runtime = SagittariusSchema.object_from_id(graphql_data_at(:runtimes_create, :runtime, :id))

    expect(runtime.name).to eq(input[:name])

    is_expected.to create_audit_event(
      :runtime_created,
      author_id: current_user.id,
      entity_id: runtime.id,
      entity_type: 'Runtime',
      details: { name: input[:name], description: '' },
      target_id: runtime.namespace.id,
      target_type: 'Namespace'
    )
  end

  context 'when adding global runtime' do
    let(:input) do
      name = generate(:runtime_name)

      {
        name: name,
      }
    end

    let(:current_user) { create(:user, admin: true) }

    it 'creates runtime' do
      expect(graphql_data_at(:runtimes_create, :runtime, :token)).to be_present
      expect(graphql_data_at(:runtimes_create, :runtime, :id)).to be_present

      runtime = SagittariusSchema.object_from_id(graphql_data_at(:runtimes_create, :runtime, :id))

      expect(runtime.name).to eq(input[:name])

      is_expected.to create_audit_event(
        :runtime_created,
        author_id: current_user.id,
        entity_id: runtime.id,
        entity_type: 'Runtime',
        details: { name: input[:name], description: '' },
        target_id: 0,
        target_type: 'global'
      )
    end
  end

  context 'when runtime name is taken' do
    let(:runtime) { create(:runtime, namespace: namespace) }
    let(:input) { { name: runtime.name, namespaceId: namespace.to_global_id.to_s } }

    it 'returns an error' do
      expect(graphql_data_at(:runtimes_create, :runtime)).to be_nil
      expect(graphql_data_at(:runtimes_create, :errors)).to include({ 'attribute' => 'name', 'type' => 'taken' })
    end
  end
end
