# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      class UpdateService
        include Sagittarius::Database::Transactional
        include FlowServiceHelper

        attr_reader :current_authentication, :flow, :flow_input

        def initialize(current_authentication, flow, flow_input)
          @current_authentication = current_authentication
          @flow = flow
          @flow_input = flow_input
        end

        def execute
          unless Ability.allowed?(current_authentication, :update_flow, flow)
            return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
          end

          transactional do |t|
            update_flow(t)

            create_audit_event

            ServiceResponse.success(message: 'Flow updated', payload: flow)
          end
        end

        def update_flow(t)
          update_settings(t)
          update_nodes(t)
          update_flow_attributes

          unless flow.save
            t.rollback_and_return! ServiceResponse.error(
              message: 'Flow is invalid',
              error_code: :invalid_flow,
              details: flow.errors
            )
          end

          validate_flow(t)

          UpdateRuntimesForProjectJob.perform_later(flow.project.id)
        end

        private

        def update_flow_attributes
          flow.name = flow_input.name
        end

        def update_settings(t)
          flow_input.settings&.each do |setting|
            flow_setting = flow.flow_settings.find_or_initialize_by(flow_setting_id: setting.flow_setting_identifier)
            flow_setting.object = setting.value

            next if flow_setting.valid?

            t.rollback_and_return! ServiceResponse.error(
              message: 'Invalid flow settings',
              error_code: :invalid_flow_setting,
              details: flow_setting.errors
            )
          end

          flow.flow_settings.where.not(flow_setting_id: flow_input.settings.map(&:flow_setting_identifier)).destroy_all
        end

        def update_nodes(t)
          all_nodes = flow.node_functions

          flow_input.starting_node_id
          node_index = 0

          updated_nodes = []

          flow_input.nodes.each do |node_input|
            current_node = all_nodes[node_index] || NodeFunction.new(flow: flow)

            update_node(t, current_node, node_input)
            updated_nodes << { node: current_node, input: node_input }

            node_index += 1
          end

          updated_nodes.each do |node|
            update_node_parameters(t, node[:node], node[:input], updated_nodes)
            update_next_node(t, node[:node], node[:input], updated_nodes)

            next if node[:node].save

            t.rollback_and_return! ServiceResponse.error(
              message: 'Invalid node',
              error_code: :invalid_node_function,
              details: node[:node].errors
            )
          end

          update_starting_node(t, updated_nodes)

          delete_old_nodes(t, all_nodes.reject { |node| updated_nodes.pluck(:node).pluck(:id).include?(node.id) })
        end

        def update_starting_node(t, all_nodes)
          starting_node = all_nodes.find { |n| n[:input].id == flow_input.starting_node_id }

          if starting_node.nil? && flow_input.starting_node_id.present?
            t.rollback_and_return! ServiceResponse.error(
              message: 'Starting node not found',
              error_code: :node_not_found
            )
          end
          return if starting_node.nil?

          flow.starting_node = starting_node[:node]
        end

        def delete_old_nodes(t, remaining_nodes)
          remaining_nodes.each do |node|
            node.destroy
            next unless node.persisted?

            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to delete node',
              error_code: :invalid_node_function,
              details: node.errors
            )
          end
        end

        def update_node(t, current_node, current_node_input)
          runtime_function_definition = flow.project.primary_runtime.runtime_function_definitions.find_by(
            id: current_node_input.runtime_function_id.model_id
          )
          if runtime_function_definition.nil?
            t.rollback_and_return! ServiceResponse.error(
              message: 'Invalid runtime function id',
              error_code: :invalid_runtime_function_id
            )
          end

          current_node.runtime_function = runtime_function_definition
        end

        def update_next_node(t, current_node, current_node_input, all_nodes)
          next_node = all_nodes.find { |n| n[:input].id == current_node_input.next_node_id }

          if next_node.nil? && current_node_input.next_node_id.present?
            t.rollback_and_return! ServiceResponse.error(
              message: 'Next node not found',
              error_code: :node_not_found
            )
          end

          current_node.next_node = next_node&.[](:node)
        end

        def update_node_parameters(t, current_node, current_node_input, all_nodes)
          db_parameters = current_node.node_parameters.first(current_node_input.parameters.count)
          current_node_input.parameters.each_with_index do |parameter, index|
            db_parameters[index] ||= current_node.node_parameters.build

            runtime_parameter = current_node.runtime_function.parameters.find_by(
              id: parameter.runtime_parameter_definition_id.model_id
            )
            if runtime_parameter.nil?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Invalid runtime parameter id',
                error_code: :invalid_runtime_parameter_id
              )
            end

            db_parameters[index].runtime_parameter = runtime_parameter

            db_parameters[index].literal_value = parameter.value.literal_value

            if parameter.value.node_function_id.present?
              node = all_nodes.find { |n| n[:input].id == parameter.value.node_function_id }

              if node.nil?
                t.rollback_and_return! ServiceResponse.error(
                  message: 'Invalid function value for parameter',
                  error_code: :function_value_not_found
                )
              end

              db_parameters[index].function_value = node[:node]
            else
              db_parameters[index].function_value = nil
            end

            if parameter.value.reference_value.present?
              data_type_identifier = get_data_type_identifier(
                flow.project.primary_runtime,
                parameter.value.reference_value.data_type_identifier,
                t
              )

              referenced_node = all_nodes.find do |n|
                n[:input].id == parameter.value.reference_value.node_function_id
              end

              if referenced_node.nil?
                t.rollback_and_return! ServiceResponse.error(
                  message: 'Referenced node function not found',
                  error_code: :referenced_value_not_found
                )
              end

              db_parameters[index].reference_value ||= ReferenceValue.new
              reference_value = db_parameters[index].reference_value

              reference_paths_input = parameter.value.reference_value.reference_path
              reference_paths = reference_value.reference_paths.first(reference_paths_input.length)
              reference_paths_input.each_with_index do |path, i|
                reference_paths[i] ||= reference_value.reference_paths.build
                reference_paths[i].assign_attributes(path: path.path, array_index: path.array_index)
              end

              reference_value.assign_attributes(
                data_type_identifier: data_type_identifier,
                node_function: referenced_node[:node],
                depth: parameter.value.reference_value.depth,
                node: parameter.value.reference_value.node,
                scope: parameter.value.reference_value.scope,
                reference_paths: reference_paths
              )
            else
              db_parameters[index].reference_value = nil
            end

            next if db_parameters[index].valid?

            t.rollback_and_return! ServiceResponse.error(
              message: 'Invalid node parameter',
              error_code: :invalid_node_parameter,
              details: db_parameters[index].errors
            )
          end

          current_node.node_parameters = db_parameters
        end

        def validate_flow(t)
          res = Validation::ValidationService.new(current_authentication, flow).execute

          return unless res.error?

          t.rollback_and_return! ServiceResponse.error(
            message: 'Flow validation failed',
            error_code: res.payload[:error_code],
            details: res.payload[:details]
          )
        end

        def create_audit_event
          AuditService.audit(
            :flow_updated,
            author_id: current_authentication.user.id,
            entity: flow,
            target: flow.project,
            details: {
              **flow.attributes.except('created_at', 'updated_at'),
            }
          )
        end
      end
    end
  end
end
