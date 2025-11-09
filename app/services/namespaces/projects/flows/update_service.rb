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
            update_node_parameters(t, current_node, current_node_input)

            current_node_input = current_node_input.next_node
            node_index += 1
          end
        end

        def update_node(t, current_node, current_node_input)

        end

        def update_node_parameters(t, current_node, current_node_input)
          db_parameters = current_node.node_parameters.first(current_node_input.parameters.count)
          current_node_input.parameters.each_with_index do |parameter, index|
            db_parameters[index] ||= NodeParameter.new
            db_parameters[index].runtime_parameter_definition_id = parameter.runtime_parameter_definition_id.model_id
            if parameter.value.function_value
              db_parameters[index].function_value = SagittariusSchema.object_from_id(parameter.value.function_value.runtime_function_id)
              db_parameters[index].literal_value = nil
              db_parameters[index].reference_value = nil
            elsif parameter.value.literal_value
              db_parameters[index].literal_value = parameter.value.literal_value
              db_parameters[index].function_value = nil
              db_parameters[index].reference_value = nil
            else
              db_parameters[index].reference_value = ReferenceValue.create(
                reference_value_id: parameter.value.reference_value.reference_value_id,
                data_type_identifier: get_data_type_identifier(identifier)
              )
              db_parameters[index].literal_value = nil
              db_parameters[index].function_value = nil
            end

            next if db_parameters[index].valid?

            t.rollback_and_return! ServiceResponse.error(
              message: 'Invalid node parameter',
              payload: db_parameters[index].errors
            )
          end

          current_node.node_parameters = db_parameters
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
