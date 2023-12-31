# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
    field_class Types::BaseField

    def self.id_field(type, entity_name = graphql_name)
      field :id, Types::GlobalIdType[type], null: false, description: "Global ID of this #{entity_name}",
                                            method: :to_global_id
    end

    def self.timestamps(entity_name = graphql_name)
      field :created_at, Types::TimeType, null: false, description: "Time when this #{entity_name} was created"
      field :updated_at, Types::TimeType, null: false, description: "Time when this #{entity_name} was last updated"
    end

    def self.authorized?(object, context)
      if object.instance_variable_defined?(:@sagittarius_object_authorization_bypass)
        return object.instance_variable_get(:@sagittarius_object_authorization_bypass)
      end

      subject = object.try(:declarative_policy_subject) || object

      authorize.all? do |ability|
        Ability.allowed?(context[:current_user], ability, subject)
      end
    end

    def self.authorize(*args)
      raise 'Cannot redefine authorize' if @authorize_args && args.any?

      @authorize_args = args.freeze if args.any?
      @authorize_args || (superclass.respond_to?(:authorize) ? superclass.authorize : [])
    end

    def current_authorization
      context[:current_authorization]
    end

    def current_user
      context[:current_user]
    end
  end
end
