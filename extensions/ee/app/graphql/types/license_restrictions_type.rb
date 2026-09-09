# frozen_string_literal: true

module Types
  class LicenseRestrictionsType < Types::BaseObject
    description '(EE only) Represents the restrictions of a license'

    field :ai_tokens, GraphQL::Types::Int, null: true, description: 'AI token entitlement'
    field :user_count, GraphQL::Types::Int, null: true, description: 'Maximum number of regular users'
    field :workflow_executions, GraphQL::Types::Int, null: true, description: 'Workflow execution entitlement'
  end
end
