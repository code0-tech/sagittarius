# frozen_string_literal: true

module Subscriptions
  module Namespaces
    module Projects
      module Flows
        class ExecutionResult < BaseSubscription
          description 'Subscription to asynchronously receive an execution result'

          argument :execution_identifier,
                   type: GraphQL::Types::String,
                   required: true,
                   description: 'Execution identifier of the triggered execution'

          field :execution_result,
                type: Types::ExecutionResultType,
                null: true,
                description: 'The execution result of the relevant execution'

          def subscribe(execution_identifier:)
            result = ::ExecutionResult.find_by(execution_identifier: execution_identifier)

            if result.present?
              unsubscribe({ execution_result: result })
            else
              :no_response
            end
          end

          def update(*)
            unsubscribe({ execution_result: object })
          end
        end
      end
    end
  end
end
