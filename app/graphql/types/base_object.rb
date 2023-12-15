# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
    field_class Types::BaseField

    def self.timestamps(entity_name = graphql_name)
      field :created_at, Types::TimeType, null: false, description: "Time when this #{entity_name} was created"
      field :updated_at, Types::TimeType, null: false, description: "Time when this #{entity_name} was last updated"
    end

    def id
      object.to_global_id
    end

    def current_authorization
      context[:current_authorization]
    end

    def current_user
      context[:current_user]
    end
  end
end
