# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Namespace'] do
  let(:fields) do
    %w[
      id
      parent
      members
      roles
      runtimes
      dataTypes
      projects
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('Namespace') }
  it { expect(described_class).to have_graphql_fields(fields).allow_unexpected_if_extended }
  it { expect(described_class).to require_graphql_authorizations(:read_namespace) }

  context 'when requesting members' do
    it_behaves_like 'prevents N+1 queries (graphql)' do
      let(:query) do
        <<~QUERY
          query($namespaceId: NamespaceID!) {
            namespace(id: $namespaceId) {
              members {
                count
                nodes {
                  id
                  user { username }
                  namespace { id }
                }
              }
            }
          }
        QUERY
      end

      let(:current_user) { create(:user) }
      let(:namespace) do
        create(:namespace).tap do |namespace|
          create(:namespace_member, namespace: namespace, user: current_user)
        end
      end
      let(:variables) { { namespaceId: namespace.to_global_id.to_s } }

      let(:create_new_record) do
        -> { create(:namespace_member, namespace: namespace) }
      end
    end
  end

  context 'when requesting roles' do
    it_behaves_like 'prevents N+1 queries (graphql)' do
      let(:query) do
        <<~QUERY
          query($namespaceId: NamespaceID!) {
            namespace(id: $namespaceId) {
              roles {
                count
                nodes {
                  id
                  name
                  namespace { id }
                }
              }
            }
          }
        QUERY
      end

      let(:current_user) { create(:user) }
      let(:namespace) do
        create(:namespace).tap do |namespace|
          create(:namespace_member, namespace: namespace, user: current_user)
          create(:namespace_role, namespace: namespace)
        end
      end
      let(:variables) { { namespaceId: namespace.to_global_id.to_s } }

      let(:create_new_record) do
        -> { create(:namespace_role, namespace: namespace) }
      end
    end
  end
end
