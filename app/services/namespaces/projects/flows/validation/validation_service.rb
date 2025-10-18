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
            errors = []

            primary_runtime = flow.project.primary_runtime
            errors << ValidationResult.error(:no_primary_runtime) if primary_runtime.nil?

            # ---
            # Input Type Validation
            # ---
            if flow.input_type.present?
              errors += Namespaces::Projects::Flows::Validation::DataType::DataTypeValidationService.new(
                current_authentication,
                flow,
                flow.input_type
              ).execute
            end

            # ---
            # Return Type Validation
            # ---
            if flow.return_type.present?
              errors += Namespaces::Projects::Flows::Validation::DataType::DataTypeValidationService.new(
                current_authentication,
                flow,
                flow.return_type
              ).execute
            end

            # ---
            # Setting
            # ---
            flow.flow_settings.each do |setting|
              errors += Namespaces::Projects::Flows::Validation::FlowSettingValidationService.new(
                current_authentication,
                flow,
                setting
              ).execute
            end

            # ---
            # All nodes
            # ---
            flow.collect_node_functions.each do |node_function|
              errors += Namespaces::Projects::Flows::Validation::NodeFunction::NodeFunctionValidationService.new(
                current_authentication,
                flow,
                node_function
              ).execute
            end

            # ---
            # Flow Type
            # ---
            errors += FlowTypeValidationService.new(
              current_authentication,
              flow,
              flow.flow_type
            ).execute

            return ServiceResponse.error(message: 'Flow validation failed', payload: errors) if errors.any?

            ServiceResponse.success(message: 'Validation service executed successfully', payload: flow)
          end
        end
      end
    end
  end
end
