# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::CreateService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), namespace_project: namespace_project,
                                                             flow_input: flow_input).execute
  end

  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project, primary_runtime: runtime) }

  let(:flow_input) do
    Struct.new(:settings, :type, :starting_node_id, :nodes, :name, :disabled_reason).new(
      [],
      create(:flow_type, runtime: runtime).to_global_id,
      'gid://sagittarius/NodeFunction/12345',
      [
        Struct.new(:id, :function_definition_id, :next_node_id, :parameters).new(
          'gid://sagittarius/NodeFunction/12345',
          create(
            :function_definition,
            runtime_function_definition: create(
              :runtime_function_definition,
              runtime: runtime
            )
          ).to_global_id,
          nil,
          []
        )
      ],
      generate(:flow_name),
      nil
    )
  end

  shared_examples 'does not create' do
    it { is_expected.to be_error }

    it 'does not create flow' do
      expect { service_response }.not_to change { Flow.count }
    end

    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when user cannot create flow in project' do
    let(:current_user) { create(:user) }

    it_behaves_like 'does not create'
  end

  context 'when starting node is nil' do
    let(:current_user) { create(:user) }
    let(:flow_input) do
      Struct.new(:settings, :type, :starting_node_id, :nodes, :name, :disabled_reason).new(
        [],
        create(:flow_type, runtime: runtime).to_global_id,
        nil,
        [
          Struct.new(:id, :function_definition_id, :next_node_id, :parameters).new(
            'gid://sagittarius/NodeFunction/12345',
            create(
              :function_definition,
              runtime_function_definition: create(
                :runtime_function_definition,
                runtime: runtime
              )
            ).to_global_id,
            nil,
            []
          )
        ],
        generate(:flow_name),
        nil
      )
    end

    before do
      stub_allowed_ability(NamespaceProjectPolicy, :create_flow, user: current_user, subject: namespace_project)
    end

    it do
      is_expected.to be_success
      expect(service_response.payload).to be_valid
    end
  end

  context 'when user and params are valid' do
    let(:current_user) { create(:user) }

    before do
      stub_allowed_ability(NamespaceProjectPolicy, :create_flow, user: current_user, subject: namespace_project)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it do
      is_expected.to create_audit_event(
        :flow_created,
        author_id: current_user.id,
        entity_type: 'Flow',
        entity_id: service_response.payload.id,
        details: {
          **service_response.payload.attributes.except('created_at', 'updated_at'),
        },
        target_id: namespace_project.id,
        target_type: 'NamespaceProject'
      )
    end

    it 'queues job to update runtimes' do
      allow(UpdateRuntimesForProjectJob).to receive(:perform_later)

      service_response

      expect(UpdateRuntimesForProjectJob).to have_received(:perform_later).with(namespace_project.id)
    end
  end
end
