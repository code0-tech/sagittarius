# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        class ValidationService
          include Sagittarius::Database::Transactional

          attr_reader :current_authentication, :flow

          def initialize(current_authentication, flow)
            @current_authentication = current_authentication
            @flow = flow
          end

          def execute
            transactional do |_t|
              primary_runtime = flow.project.primary_runtime
              if primary_runtime.nil?
                return ServiceResponse.error(
                  message: 'No primary runtime found for the project, first configure a primary runtime',
                  payload: :no_primary_runtime
                )
              end

              # ---
              # Input Type Validation
              # ---
              if flow.input_type.present?
                Namespaces::Projects::Flows::Validation::DataType::DataTypeValidationService.new(
                  current_authentication,
                  flow,
                  flow.input_type
                ).execute
              end

              # ---
              # Return Type Validation
              # ---
              if flow.return_type.present?
                Namespaces::Projects::Flows::Validation::DataType::DataTypeValidationService.new(
                  current_authentication,
                  flow,
                  flow.return_type
                ).execute
              end

              # ---
              # Setting
              # ---
              flow.flow_settings.each do |setting|
                Namespaces::Projects::Flows::Validation::FlowSettingValidationService.new(
                  current_authentication,
                  flow,
                  setting
                ).execute
              end

              # ---
              # Starting node
              # ---
              Namespaces::Projects::Flows::Validation::NodeFunction::NodeFunctionValidationService.new(
                current_authentication,
                flow,
                flow.starting_node
              ).execute

              # ---
              # Flow Type
              # ---
              FlowTypeValidationService.new(
                current_authentication,
                flow,
                flow.flow_type
              ).execute

              ServiceResponse.success(message: 'Validation service executed successfully', payload: flow)
            end
          end
        end
      end
    end
  end
end
