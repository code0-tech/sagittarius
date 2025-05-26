# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      class ValidationService
        include Sagittarius::Database::Transactional

        attr_reader :current_authentication, :flow

        def initialize(current_authentication, flow)
          @current_authentication = current_authentication
          @flow = flow
        end

        def execute
          # TODO: Implement validation logic for the flow
          ServiceResponse.success(message: 'Validation service executed successfully', payload: flow)
        end
      end
    end
  end
end
