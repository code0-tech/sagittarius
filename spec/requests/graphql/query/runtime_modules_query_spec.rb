# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'runtime modules Query' do
  include GraphqlHelpers

  let(:namespace) { create(:namespace) }
  let(:runtime) { create(:runtime, namespace: namespace) }
  let(:runtime_module) do
    create(:runtime_module,
           runtime: runtime,
           identifier: 'core',
           documentation: 'https://example.com/docs/core',
           author: 'Tucana',
           icon: 'tabler:box',
           version: '1.2.3')
  end
  let(:data_type) { create(:data_type, runtime_module: runtime_module, identifier: 'STRING') }
  let(:runtime_flow_type) do
    create(:runtime_flow_type, runtime_module: runtime_module, identifier: 'runtime-flow')
  end
  let(:runtime_flow_type_setting) do
    create(:runtime_flow_type_setting,
           runtime_flow_type: runtime_flow_type,
           identifier: 'scope',
           unique: :project)
  end
  let(:flow_type) do
    create(:flow_type, runtime_module: runtime_module, runtime_flow_type: runtime_flow_type, identifier: 'flow')
  end
  let(:runtime_function_definition) do
    create(:runtime_function_definition, runtime_module: runtime_module, runtime_name: 'runtime_function')
  end
  let(:function_definition) do
    create(:function_definition,
           runtime_module: runtime_module,
           runtime_function_definition: runtime_function_definition,
           identifier: 'function')
  end
  let(:module_configuration_definition) do
    create(:module_configuration_definition,
           runtime_module: runtime_module,
           identifier: 'apiKey',
           type: 'STRING',
           default_value: 'abc',
           optional: true,
           hidden: true)
  end
  let(:current_user) do
    create(:user).tap do |user|
      create(:namespace_member, user: user, namespace: namespace)
    end
  end

  let(:query) do
    <<~QUERY
      query($namespaceId: NamespaceID!) {
        namespace(id: $namespaceId) {
          runtimes {
            nodes {
              id
              modules {
                nodes {
                  id
                  identifier
                  documentation
                  author
                  icon
                  version
                  dataTypes { nodes { id identifier runtimeModule { id } } }
                  runtimeFlowTypes {
                    nodes {
                      id
                      identifier
                      runtimeModule { id }
                      flowTypes { nodes { id identifier runtimeFlowType { id } runtimeModule { id } } }
                      linkedDataTypes { nodes { id } }
                      runtimeFlowTypeSettings { id identifier unique }
                    }
                  }
                  runtimeFunctionDefinitions {
                    nodes {
                      id
                      identifier
                      runtimeModule { id }
                    }
                  }
                  functionDefinitions {
                    nodes {
                      id
                      identifier
                      runtime { id }
                      runtimeFunctionDefinition { id }
                      runtimeModule { id }
                    }
                  }
                  configurationDefinitions {
                    nodes {
                      id
                      identifier
                      type
                      defaultValue
                      optional
                      hidden
                      runtimeModule { id }
                      linkedDataTypes { nodes { id } }
                    }
                  }
                }
              }
            }
          }
        }
      }
    QUERY
  end

  before do
    create(:runtime_flow_type_data_type_link, runtime_flow_type: runtime_flow_type, referenced_data_type: data_type)
    runtime_flow_type_setting
    create(:module_configuration_definition_data_type_link,
           module_configuration_definition: module_configuration_definition,
           referenced_data_type: data_type)
    flow_type
    function_definition

    post_graphql query,
                 variables: { namespaceId: namespace.to_global_id.to_s },
                 current_user: current_user
  end

  it 'returns the module and its definitions' do
    module_node = graphql_data_at(:namespace, :runtimes, :nodes, 0, :modules, :nodes, 0)

    expect(module_node).to include(
      'id' => runtime_module.to_global_id.to_s,
      'identifier' => 'core',
      'documentation' => 'https://example.com/docs/core',
      'author' => 'Tucana',
      'icon' => 'tabler:box',
      'version' => '1.2.3'
    )
    expect(module_node.dig('dataTypes', 'nodes')).to contain_exactly(
      a_hash_including(
        'id' => data_type.to_global_id.to_s,
        'identifier' => 'STRING',
        'runtimeModule' => { 'id' => runtime_module.to_global_id.to_s }
      )
    )
    expect(module_node.dig('runtimeFlowTypes', 'nodes')).to contain_exactly(
      a_hash_including(
        'id' => runtime_flow_type.to_global_id.to_s,
        'identifier' => 'runtime-flow',
        'runtimeModule' => { 'id' => runtime_module.to_global_id.to_s },
        'linkedDataTypes' => {
          'nodes' => contain_exactly(a_hash_including('id' => data_type.to_global_id.to_s)),
        },
        'runtimeFlowTypeSettings' => contain_exactly(
          a_hash_including(
            'id' => runtime_flow_type_setting.to_global_id.to_s,
            'identifier' => 'scope',
            'unique' => 'project'
          )
        ),
        'flowTypes' => {
          'nodes' => contain_exactly(
            a_hash_including(
              'id' => flow_type.to_global_id.to_s,
              'identifier' => 'flow',
              'runtimeFlowType' => { 'id' => runtime_flow_type.to_global_id.to_s },
              'runtimeModule' => { 'id' => runtime_module.to_global_id.to_s }
            )
          ),
        }
      )
    )
    expect(module_node.dig('runtimeFunctionDefinitions', 'nodes')).to contain_exactly(
      a_hash_including(
        'id' => runtime_function_definition.to_global_id.to_s,
        'identifier' => 'runtime_function',
        'runtimeModule' => { 'id' => runtime_module.to_global_id.to_s }
      )
    )
    expect(module_node.dig('functionDefinitions', 'nodes')).to contain_exactly(
      a_hash_including(
        'id' => function_definition.to_global_id.to_s,
        'identifier' => 'function',
        'runtime' => { 'id' => runtime.to_global_id.to_s },
        'runtimeFunctionDefinition' => { 'id' => runtime_function_definition.to_global_id.to_s },
        'runtimeModule' => { 'id' => runtime_module.to_global_id.to_s }
      )
    )
    expect(module_node.dig('configurationDefinitions', 'nodes')).to contain_exactly(
      a_hash_including(
        'id' => module_configuration_definition.to_global_id.to_s,
        'identifier' => 'apiKey',
        'type' => 'STRING',
        'defaultValue' => 'abc',
        'optional' => true,
        'hidden' => true,
        'runtimeModule' => { 'id' => runtime_module.to_global_id.to_s },
        'linkedDataTypes' => {
          'nodes' => contain_exactly(a_hash_including('id' => data_type.to_global_id.to_s)),
        }
      )
    )
  end
end
