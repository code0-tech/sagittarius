# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    include Sagittarius::Graphql::HasMarkdownDocumentation
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::CountableConnectionType)
    field_class Types::BaseField

    def self.id_field(type, entity_name = graphql_name)
      field :id, Types::GlobalIdType[type], null: false, description: "Global ID of this #{entity_name}",
                                            method: :to_global_id
    end

    def self.timestamps(entity_name = graphql_name)
      field :created_at, Types::TimeType, null: false, description: "Time when this #{entity_name} was created"
      field :updated_at, Types::TimeType, null: false, description: "Time when this #{entity_name} was last updated"
    end

    def self.lookahead_field(field, base_scope:, lookaheads: [], conditional_lookaheads: {})
      define_method(field) do |*_args, lookahead:, **_kwargs|
        field_selected = lambda do |f|
          lookahead.selects?(f) ||
            lookahead.selection(:nodes).selects?(f) ||
            lookahead.selection(:edges).selection(:node).selects?(f)
        end

        scope = lookaheads.reduce(base_scope.call(object)) { |acc, f| acc.preload(f) }

        conditional_lookaheads.reduce(scope) do |acc, (f, preload_field)|
          field_selected.call(f) ? acc.preload(preload_field) : acc
        end
      end
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
