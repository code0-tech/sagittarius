# frozen_string_literal: true

module Types
  class DailyRuntimeUsageType < Types::BaseObject
    description 'Represents runtime usage for a flow on a specific day'

    authorize :read_namespace
    declarative_policy_subject(&:namespace)

    field :day, Types::DateType, null: false, description: 'The day this usage was recorded for'
    field :flow, Types::FlowType, null: true, description: 'The flow this usage was recorded for'
    field :namespace, Types::NamespaceType, null: false, description: 'The namespace this usage belongs to'
    field :usage, Float, null: false, description: 'The accumulated runtime usage for the day'

    id_field DailyRuntimeUsage
    timestamps
  end
end
