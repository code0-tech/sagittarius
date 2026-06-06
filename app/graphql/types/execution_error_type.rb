# frozen_string_literal: true

module Types
  class ExecutionErrorType < Types::BaseObject
    description 'Represents an execution error returned by the runtime'

    field :category, String, null: true, description: 'Category of the runtime error'
    field :code, String, null: true, description: 'Code of the runtime error'
    field :dependencies, GraphQL::Types::JSON, null: false, description: 'Dependency versions for the runtime error'
    field :details, GraphQL::Types::JSON, null: true, description: 'Structured runtime error details'
    field :message, String, null: true, description: 'Message of the runtime error'
    field :timestamp, Types::BigIntType,
          null: true,
          description: 'Unix epoch runtime timestamp in microseconds for the error'
    field :version, String, null: true, description: 'Runtime version that returned the error'

    def timestamp
      return if object['timestamp'].nil?

      Integer(object['timestamp'])
    end
  end
end
