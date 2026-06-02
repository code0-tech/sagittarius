# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'flow dailyRuntimeUsages Query' do
  include GraphqlHelpers

  let(:query) do
    <<~QUERY
      query($namespaceId: NamespaceID!, $projectId: NamespaceProjectID!, $flowId: FlowID!, $from: Date, $to: Date) {
        namespace(id: $namespaceId) {
          project(id: $projectId) {
            flow(id: $flowId) {
              dailyRuntimeUsages(from: $from, to: $to) {
                nodes {
                  id
                  day
                  usage
                  namespace { id }
                }
              }
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
  let!(:later_runtime_usage) do
    create(:daily_runtime_usage, namespace: namespace, flow: flow, day: Date.new(2026, 5, 11), usage: 8)
  end
  let!(:other_flow_usage) do
    create(:daily_runtime_usage, namespace: namespace, flow: other_flow, day: Date.new(2026, 5, 11), usage: 13)
  end
  let(:variables) do
    {
      namespaceId: namespace.to_global_id.to_s,
      projectId: project.to_global_id.to_s,
      flowId: flow.to_global_id.to_s,
    }
  end

  before do
    post_graphql query, variables: variables, current_user: current_user
  end

  it 'returns runtime usages for the flow' do
    usage_nodes = graphql_data_at(:namespace, :project, :flow, :daily_runtime_usages, :nodes)

    expect(usage_nodes).to contain_exactly(
      a_hash_including(
        'id' => runtime_usage.to_global_id.to_s,
        'day' => '2026-05-10',
        'usage' => 5.0,
        'namespace' => { 'id' => namespace.to_global_id.to_s }
      ),
      a_hash_including(
        'id' => later_runtime_usage.to_global_id.to_s,
        'day' => '2026-05-11',
        'usage' => 8.0,
        'namespace' => { 'id' => namespace.to_global_id.to_s }
      )
    )
    expect(usage_nodes.pluck('id')).not_to include(other_flow_usage.to_global_id.to_s)
  end

  context 'with date filtering' do
    let(:variables) do
      {
        namespaceId: namespace.to_global_id.to_s,
        projectId: project.to_global_id.to_s,
        flowId: flow.to_global_id.to_s,
        from: '2026-05-11',
        to: '2026-05-11',
      }
    end

    it 'returns only usage in the requested date range' do
      usage_ids = graphql_data_at(:namespace, :project, :flow, :daily_runtime_usages, :nodes).pluck('id')

      expect(usage_ids).to contain_exactly(
        later_runtime_usage.to_global_id.to_s
      )
    end
  end
end
