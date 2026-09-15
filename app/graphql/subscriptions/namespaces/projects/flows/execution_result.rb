# frozen_string_literal: true

module Subscriptions
  module Namespaces
    module Projects
      module Flows
        class ExecutionResult < BaseSubscription
          description 'Subscription to asynchronously receive an execution result'

          argument :flow_id,
                   type: Types::GlobalIdType[Flow],
                   required: true,
                   description: 'Id of the flow to receive execution results for'

          field :execution_result,
                type: Types::ExecutionResultType,
                null: true,
                description: 'The most recent execution result of the relevant flow'

          def update(*)
            { execution_result: object }
          end
        end
      end
    end
  end
end
