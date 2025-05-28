# frozen_string_literal: true

module Mutations
  module Namespaces
    module Projects
      module Flows
        class Create < BaseMutation
          description 'Creates a new flow.'

          field :flow, Types::FlowType, null: true, description: 'The newly created flow.'

          argument :flow, Types::Input::FlowInputType

          def resolve(namespace_id:, **params)
            # TODO
          end
        end
      end
    end
  end
end
