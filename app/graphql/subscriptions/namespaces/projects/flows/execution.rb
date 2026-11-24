# frozen_string_literal: true

module Subscriptions
  module Namespaces
    module Projects
      module Flows
        class Execution < BaseSubscription
          description <<~DESC
            Subscription to asynchronously receive an execution.

            This subscription only notifies about new executions. The full execution result
            details are available via the [`Flow.executionResult`](../object/flow.md#executionresult) query.
          DESC

          argument :flow_id,
                   type: Types::GlobalIdType[Flow],
                   required: true,
                   description: 'Id of the flow to receive executions for'

          field :execution_identifier,
                type: GraphQL::Types::String,
                null: false,
                description: 'The execution identifier of the new execution'

          def update(*)
            { execution_identifier: object }
          end
        end
      end
    end
  end
end
