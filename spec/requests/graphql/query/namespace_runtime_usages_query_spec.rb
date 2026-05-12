# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespace dailyRuntimeUsages Query' do
  include GraphqlHelpers

  let(:query) do
    <<~QUERY
      query($namespaceId: NamespaceID!, $flowId: FlowID, $from: Date, $to: Date) {
        namespace(id: $namespaceId) {
          dailyRuntimeUsages(flowId: $flowId, from: $from, to: $to) {
            nodes {
              id
              day
              usage
              flow { id }
              namespace { id }
            }
          }
        }
      }
    QUERY
  end

  let(:current_user) do
    create(:user).tap do |user|
      member = create(:namespace_member, namespace: namespace, user: user)
      role = create(:namespace_role, namespace: namespace)
      create(:namespace_member_role, member: member, role: role)
      create(:namespace_role_project_assignment, role: role, project: project)
      create(:namespace_role_ability, namespace_role: role, ability: :read_namespace_project)
    end
  end

  let(:namespace) { create(:namespace) }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:flow) { create(:flow, project: project) }
  let(:other_flow) { create(:flow, project: project) }
  let!(:runtime_usage) do
    create(:daily_runtime_usage, namespace: namespace, flow: flow, day: Date.new(2026, 5, 10), usage: 5)
  end
  let!(:other_runtime_usage) do
    create(:daily_runtime_usage, namespace: namespace, flow: other_flow, day: Date.new(2026, 5, 11), usage: 8)
  end
  let(:variables) { { namespaceId: namespace.to_global_id.to_s } }

  before do
    post_graphql query, variables: variables, current_user: current_user
  end

  it 'returns runtime usages for the namespace' do
    expect(graphql_data_at(:namespace, :daily_runtime_usages, :nodes)).to contain_exactly(
      a_hash_including(
        'id' => runtime_usage.to_global_id.to_s,
        'day' => '2026-05-10',
        'usage' => 5.0,
        'flow' => { 'id' => flow.to_global_id.to_s },
        'namespace' => { 'id' => namespace.to_global_id.to_s }
      ),
      a_hash_including(
        'id' => other_runtime_usage.to_global_id.to_s,
        'day' => '2026-05-11',
        'usage' => 8.0,
        'flow' => { 'id' => other_flow.to_global_id.to_s },
        'namespace' => { 'id' => namespace.to_global_id.to_s }
      )
    )
  end

  context 'with flow filtering' do
    let(:variables) do
      {
        namespaceId: namespace.to_global_id.to_s,
        flowId: flow.to_global_id.to_s,
      }
    end

    it 'returns only usage for the requested flow' do
      expect(graphql_data_at(:namespace, :daily_runtime_usages, :nodes).pluck('id')).to contain_exactly(
        runtime_usage.to_global_id.to_s
      )
    end
  end

  context 'with date filtering' do
    let(:variables) do
      {
        namespaceId: namespace.to_global_id.to_s,
        from: '2026-05-11',
        to: '2026-05-11',
      }
    end

    it 'returns only usage in the requested date range' do
      expect(graphql_data_at(:namespace, :daily_runtime_usages, :nodes).pluck('id')).to contain_exactly(
        other_runtime_usage.to_global_id.to_s
      )
    end
  end

  context 'when the flow was deleted' do
    before do
      runtime_usage.flow.delete
      post_graphql query, variables: variables, current_user: current_user
    end

    it 'keeps the usage visible through the namespace with nil flow' do
      usage = graphql_data_at(:namespace, :daily_runtime_usages, :nodes).find do |node|
        node['id'] == runtime_usage.to_global_id.to_s
      end

      expect(usage['flow']).to be_nil
      expect(usage['namespace']).to eq({ 'id' => namespace.to_global_id.to_s })
    end
  end

  context 'when user is not a namespace member' do
    let(:current_user) { create(:user) }

    it 'returns nil for the namespace' do
      expect(graphql_data_at(:namespace)).to be_nil
      expect_graphql_errors_to_be_empty
    end
  end
end
