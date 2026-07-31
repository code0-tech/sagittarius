# frozen_string_literal: true

class FlowHandler < Tucana::Sagittarius::Rails::FlowService::Service
  include Code0::ZeroTrack::Loggable
  include GrpcHandler

  # Called by the gateway when Aquila (re)connects. Returns the runtime's full valid-flow state.
  def update(_request, _call)
    current_runtime = Runtime.find(Code0::ZeroTrack::Context.current[:runtime][:id])

    Tucana::Sagittarius::Rails::FlowResponse.new(flows: flows_for(current_runtime))
  end

  def self.update_flow(flow)
    response = Tucana::Sagittarius::Gateway::FlowResponse.new(updated_flow: flow.to_grpc)
    push_to_project_runtimes(flow.project, response)
  end

  def self.delete_flow(project, flow_id)
    response = Tucana::Sagittarius::Gateway::FlowResponse.new(deleted_flow_id: flow_id)
    push_to_project_runtimes(project, response)
  end

  def self.push_to_project_runtimes(project, response)
    project.runtime_assignments.compatible.find_each do |assignment|
      gateway_client.push_flow(assignment.runtime_id, response)
    end
  end

  def self.update_runtime(runtime)
    assignments = runtime.project_assignments.compatible.includes(
      :namespace_project,
      module_configurations: { module_configuration_definition: :runtime_module }
    )
    runtime_modules = runtime.runtime_modules.includes(:module_configuration_definitions)

    gateway_client.push_flow(
      runtime.id,
      Tucana::Sagittarius::Gateway::FlowResponse.new(
        flows: Tucana::Shared::Flows.new(
          flows: []
        )
      )
    )

    assignments.each do |assignment|
      assignment.namespace_project.flows.validation_status_valid.each do |flow|
        gateway_client.push_flow(
          runtime.id,
          Tucana::Sagittarius::Gateway::FlowResponse.new(updated_flow: flow.to_grpc)
        )
      end
    end

    grouped_module_configurations(assignments, runtime_modules).each do |module_configuration|
      gateway_client.push_module_configuration(
        runtime.id,
        Tucana::Sagittarius::Gateway::ModuleConfigurationResponse.new(
          module_configurations: module_configuration
        )
      )
    end
  end

  def self.gateway_client
    @gateway_client ||= Sagittarius::Gateway::Client.new
  end

  def self.grouped_module_configurations(assignments, runtime_modules)
    grouped_entries = assignments.flat_map do |assignment|
      saved_configurations = assignment.module_configurations.index_by(&:module_configuration_definition_id)

      runtime_modules.flat_map do |runtime_module|
        runtime_module.module_configuration_definitions.map do |definition|
          [
            runtime_module.identifier,
            assignment,
            saved_configurations[definition.id] || definition
          ]
        end
      end
    end.group_by(&:first)

    grouped_entries.sort_by(&:first).map do |module_identifier, entries|
      Tucana::Shared::ModuleConfigurations.new(
        module_identifier: module_identifier,
        module_configurations: grouped_project_configurations(entries)
      )
    end
  end

  def self.grouped_project_configurations(entries)
    entries.group_by { |_, assignment, _| assignment.id }
           .sort_by { |_, grouped_entries| grouped_entries.first[1].namespace_project_id }
           .map do |_, grouped_entries|
             assignment = grouped_entries.first[1]
             Tucana::Shared::ModuleProjectConfigurations.new(
               project_id: assignment.namespace_project_id,
               module_configurations: grpc_module_configurations(grouped_entries)
             )
           end
  end

  def self.grpc_module_configurations(entries)
    entries.map(&:last)
           .sort_by { |configuration| module_configuration_identifier(configuration) }
           .map { |configuration| module_configuration_to_grpc(configuration) }
  end

  def self.module_configuration_identifier(configuration)
    return configuration.identifier if configuration.is_a?(ModuleConfigurationDefinition)

    configuration.module_configuration_definition.identifier
  end

  def self.module_configuration_to_grpc(configuration)
    return configuration.to_default_grpc if configuration.is_a?(ModuleConfigurationDefinition)

    configuration.to_grpc
  end

  def flows_for(runtime)
    assignments = runtime.project_assignments.compatible.includes(:namespace_project)

    flows = assignments.flat_map do |assignment|
      assignment.namespace_project.flows.validation_status_valid.map(&:to_grpc)
    end

    Tucana::Shared::Flows.new(flows: flows)
  end
end
