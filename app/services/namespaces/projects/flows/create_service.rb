# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      class CreateService
        include Sagittarius::Database::Transactional

        attr_reader :current_authentication, :namespace_project, :params

        def initialize(current_authentication, namespace_project:, **params)
          @current_authentication = current_authentication
          @namespace_project = namespace_project
          @params = params
        end

        def execute
          unless Ability.allowed?(current_authentication, :create_flow, namespace_project)
            return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
          end

          if namespace_project.primary_runtime.nil?
            return ServiceResponse.error(
              message: 'Project has no primary runtime',
              error_code: :no_primary_runtime
            )
          end

          transactional do |t|
            settings = []
            if params.key?(:flow_settings)
              params[:flow_settings].each do |graphql_setting|
                setting = FlowSetting.new(flow_setting_id: graphql_setting.flow_setting_identifier,
                                          object: graphql_setting.value)
                if setting.invalid?
                  t.rollback_and_return! ServiceResponse.error(
                    message: 'Invalid flow setting',
                    error_code: :invalid_flow_setting,
                    details: setting.errors
                  )
                end

                settings << setting
              end
              params[:flow_settings] = settings
            end

            if params.key?(:starting_node_id)
              params[:starting_node] = create_node_function(params[:starting_node_id], params[:nodes], t)

              params.delete(:starting_node_id)
              params.delete(:nodes)
            end

            flow = Flow.create(project: namespace_project, **params)
            unless flow.persisted?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Failed to create flow',
                error_code: :invalid_flow,
                details: flow.errors
              )
            end

            res = Validation::ValidationService.new(current_authentication, flow).execute

            if res.error?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Flow validation failed',
                error_code: :flow_validation_failed,
                details: res.payload
              )
            end

            UpdateRuntimesForProjectJob.perform_later(namespace_project.id)

            AuditService.audit(
              :flow_created,
              author_id: current_authentication.user.id,
              entity: flow,
              target: namespace_project,
              details: {
                **flow.attributes.except('created_at', 'updated_at'),
              }
            )

            ServiceResponse.success(message: 'Created new flow', payload: flow)
          end
        end

        def create_node_function(node_function_id, input_nodes, t)
          node_function = input_nodes.find { |n| n.id == node_function_id }

          runtime_function_definition = namespace_project.primary_runtime.runtime_function_definitions.find_by(
            id: node_function.runtime_function_id.model_id
          )
          if runtime_function_definition.nil?
            t.rollback_and_return! ServiceResponse.error(
              message: 'Invalid runtime function id',
              error_code: :invalid_runtime_function_id
            )
          end

          params = []
          node_function.parameters.each do |parameter|
            runtime_parameter = runtime_function_definition.parameters.find_by(
              id: parameter.runtime_parameter_definition_id.model_id
            )
            if runtime_parameter.nil?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Invalid runtime parameter id',
                error_code: :invalid_runtime_parameter_id
              )
            end

            if parameter.value.literal_value.present?
              params << NodeParameter.create(
                runtime_parameter: runtime_parameter,
                literal_value: parameter.value.literal_value
              )
              next
            end
            if parameter.value.function_value.present?
              params << NodeParameter.create(
                runtime_parameter: runtime_parameter,
                function_value: create_node_function(parameter.value.function_value, t)
              )
              next
            end

            referenced_node = NodeFunction.joins(:runtime_function).find_by(
              id: parameter.value.reference_value.node_function_id.model_id,
              runtime_function_definitions: { runtime_id: namespace_project.primary_runtime.id }
            )

            if referenced_node.nil?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Referenced node function not found',
                error_code: :referenced_value_not_found
              )
            end

            params << NodeParameter.create(
              runtime_parameter: runtime_parameter,
              reference_value: ReferenceValue.create(
                node_function: referenced_node,
                data_type_identifier: get_data_type_identifier(parameter.value.reference_value.data_type_identifier, t),
                depth: parameter.value.reference_value.depth,
                node: parameter.value.reference_value.node,
                scope: parameter.value.reference_value.scope,
                reference_paths: parameter.value.reference_value.reference_paths.map do |path|
                  ReferencePath.create(
                    path: path.path,
                    array_index: path.array_index
                  )
                end
              )
            )
          end

          next_node = if node_function.next_node_id.present?
                        create_node_function(node_function.next_node_id, input_nodes, t)
                      end

          NodeFunction.create(
            next_node: next_node,
            runtime_function: runtime_function_definition,
            node_parameters: params
          )
        end

        private

        def get_data_type_identifier(identifier, t)
          return DataTypeIdentifier.create(generic_key: identifier.generic_key) if identifier.generic_key.present?

          if identifier.generic_type.present?
            data_type = namespace_project.primary_runtime.data_types.find_by(
              id: identifier.generic_type.data_type_id.model_id
            )

            if data_type.nil?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Data type not found',
                error_code: :data_type_not_found
              )
            end

            mappers = identifier.generic_type.mappers.map do |mapper|
              GenericMapper.create(
                generic_mapper_id: mapper.generic_mapper_id,
                source: mapper.source,
                target: mapper.target
              )
            end
            return DataTypeIdentifier.create(generic_type: GenericType.create(data_type: data_type, mappers: mappers))
          end

          return if identifier.data_type_id.blank?

          data_type = namespace_project.primary_runtime.data_types.find_by(id: identifier.data_type_id.model_id)

          if data_type.nil?
            t.rollback_and_return! ServiceResponse.error(
              message: 'Data type not found',
              error_code: :data_type_not_found
            )
          end

          DataTypeIdentifier.create(data_type: data_type)
        end
      end
    end
  end
end
