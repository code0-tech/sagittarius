# frozen_string_literal: true

class FlowHandler < Tucana::Sagittarius::FlowService::Service
  include Code0::ZeroTrack::Loggable
  include GrpcHandler
  include GrpcStreamHandler

  grpc_stream :update

  def self.update_runtime(runtime)
    assignments = runtime.project_assignments.compatible.includes(
      :namespace_project,
      module_configurations: { module_configuration_definition: :runtime_module }
    )
    runtime_modules = runtime.runtime_modules.includes(:module_configuration_definitions)

    flows = []
    assignments.each do |assignment|
      assignment.namespace_project.flows.validation_status_valid.each do |flow|
        flows << flow.to_grpc
      end
    end

    send_update(
      Tucana::Sagittarius::FlowResponse.new(
        flows: Tucana::Shared::Flows.new(
          flows: flows
        )
      ),
      runtime.id
    )

    grouped_module_configurations(assignments, runtime_modules).each do |module_configuration|
      send_update(
        Tucana::Sagittarius::FlowResponse.new(
          module_configurations: module_configuration
        ),
        runtime.id
      )
    end
  end

  def self.update_started(runtime_id)
    runtime = Runtime.find_by(id: runtime_id)
    return if runtime.nil?

    logger.info(message: 'Runtime connected', runtime_id: runtime.id)

    update_runtime(runtime)
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

  def self.encoders = { update: ->(grpc_object) { Tucana::Sagittarius::FlowResponse.encode(grpc_object) } }

  def self.decoders = { update: ->(string) { Tucana::Sagittarius::FlowResponse.decode(string) } }
end
