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
            transactional do |t|
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
              Namespaces::Projects::Flows::Validation::DataTypeValidationService(
                current_authentication,
                flow,
                flow.input_type
              ).execute

              # ---
              # Return Type Validation
              # ---
              Namespaces::Projects::Flows::Validation::DataTypeValidationService(
                current_authentication,
                flow,
                flow.return_type
              ).execute

              # ---
              # Setting
              # ---
              flow.flow_settings.each do |setting|
                Namespaces::Projects::Flows::Validation::FlowSettingValidationService(
                  current_authentication,
                  flow,
                  setting
                ).execute
              end

              # ---
              # Starting node
              # ---
              Namespaces::Projects::Flows::Validation::NodeFunctionValidationService(
                current_authentication,
                flow,
                flow.starting_node
              ).execute

              ServiceResponse.success(message: 'Validation service executed successfully', payload: flow)
            end
          end
        end
      end
    end
  end
end
