# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      class UpdateService
        include Sagittarius::Database::Transactional

        attr_reader :current_authentication, :flow, :flow_input

        def initialize(current_authentication, flow, flow_input)
          @current_authentication = current_authentication
          @flow = flow
          @flow_input = flow_input
        end

        def execute
          unless Ability.allowed?(current_authentication, :update_flow, flow)
            return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
          end

          transactional do |t|
            update_settings(t)
            update_nodes(t)

            validate_flow(t)

            create_audit_event

            ServiceResponse.success(message: 'Flow updated', payload: flow)
          end
        end

        private

        def update_settings(t)
          flow_input.settings.each do |setting|
            flow_setting = flow.flow_settings.find_or_initialize_by(flow_setting_id: setting.flow_setting_id)
            flow_setting.object = setting.object

            next if flow_setting.valid?

            t.rollback_and_return! ServiceResponse.error(
              message: 'Invalid flow settings',
              payload: flow_setting.errors
            )
          end

          flow.flow_settings.where.not(flow_setting_id: flow_input.settings.map(&:flow_setting_id)).destroy_all
        end

        def update_nodes(t)
          all_nodes = flow.collect_node_functions

          current_node_input = flow_input.starting_node

          node_index = 0
          until current_node_input.nil?
            current_node = all_nodes[node_index]

            update_node(t, current_node, current_node_input)

            current_node_input = current_node_input.next_node
            node_index += 1
          end
        end

        def update_node(t, current_node, current_node_input)

        end

        def update_node_parameters(t, current_node, current_node_input)
          current_node_input.parameters.each do |parameter|
            node_parameter = current_node.parameters.find_or_initialize_by(runtime_parameter_definition_id: parameter.runtime_parameter_definition_id)
            node_parameter.value = parameter.value

            next if node_parameter.valid?

            t.rollback_and_return! ServiceResponse.error(
              message: 'Invalid node parameter',
              payload: node_parameter.errors
            )
          end

          current_node.node_parameters.where.not(runtime_parameter_id: current_node_input.parameters.map(&:runtime_parameter_definition_id)).destroy_all
        end

        def validate_flow(t)
          res = Validation::ValidationService.new(current_authentication, flow).execute

          return unless res.error?

          t.rollback_and_return! ServiceResponse.error(
            message: 'Flow validation failed',
            payload: res.payload
          )
        end

        def create_audit_event
          AuditService.audit(
            :flow_updated,
            author_id: current_authentication.user.id,
            entity: flow,
            target: flow.project,
            details: {
              **flow_input.attributes.except('created_at', 'updated_at'),
            }
          )
        end
      end
    end
  end
end
