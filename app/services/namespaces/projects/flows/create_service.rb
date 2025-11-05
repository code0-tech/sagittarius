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
            return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
          end

          transactional do |t|
            settings = []
            if params.key?(:flow_settings)
              params[:flow_settings].each do |graphql_setting|
                setting = FlowSetting.new(flow_setting_id: graphql_setting.flow_setting_id,
                                          object: graphql_setting.object)
                if setting.invalid?
                  t.rollback_and_return! ServiceResponse.error(
                    message: 'Invalid flow setting',
                    payload: setting.errors
                  )
                end

                settings << setting
              end
              params[:flow_settings] = settings
            end

            if params.key?(:starting_node) && params[:starting_node].is_a?(Types::Input::NodeFunctionInputType)
              node = create_node_function(params[:starting_node], t)
              params[:starting_node] = node
            end

            flow = Flow.create(project: namespace_project, **params)
            unless flow.persisted?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Failed to create flow',
                payload: flow.errors
              )
            end

            res = Validation::ValidationService.new(current_authentication, flow).execute

            if res.error?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Flow validation failed',
                payload: res.payload
              )
            end

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

        def create_node_function(node_function, t)
          runtime_function_definition = SagittariusSchema.object_from_id(node_function.runtime_function_id)
          if runtime_function_definition.nil?
            t.rollback_and_return! ServiceResponse.error(
              message: 'Invalid runtime function id',
              payload: :invalid_runtime_function_id
            )
          end

          params = []
          node_function.parameters.each do |parameter|
            runtime_parameter = SagittariusSchema.object_from_id(parameter.runtime_parameter_definition_id)
            if runtime_parameter.nil?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Invalid runtime parameter id',
                payload: :invalid_runtime_parameter_id
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

            identifier = parameter.value.reference_value.data_type_identifier

            ReferenceValue.create(
              reference_value_id: parameter.value.reference_value.reference_value_id,
              data_type_identifier: get_data_type_identifier(identifier)
            )
          end

          next_node = nil
          next_node = create_node_function(node_function.next_node, t) if node_function.next_node.present?

          NodeFunction.create(
            next_node: next_node,
            runtime_function: runtime_function_definition,
            node_parameters: params
          )
        end

        private

        def get_data_type_identifier(identifier)
          return DataTypeIdentifier.create(generic_key: identifier.generic_key) if identifier.generic_key.present?

          if identifier.generic_type.present?
            data_type = SagittariusSchema.object_from_id(identifier.generic_type.data_type_id)
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

          DataTypeIdentifier.create(data_type: SagittariusSchema.object_from_id(identifier.data_type_id))
        end
      end
    end
  end
end
