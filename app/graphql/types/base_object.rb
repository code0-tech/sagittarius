# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    include Sagittarius::Graphql::HasMarkdownDocumentation

    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::CountableConnectionType)
    field_class Types::BaseField

    def self.inherited(subclass)
      super
      return if subclass.name.blank?

      subclass.graphql_name subclass.name.delete_prefix('Types::').gsub('::', '').delete_suffix('Type')
    end

    def self.id_field(type, entity_name = graphql_name)
      field :id, Types::GlobalIdType[type], null: false, description: "Global ID of this #{entity_name}",
                                            method: :to_global_id
    end

    def self.timestamps(entity_name = graphql_name)
      field :created_at, Types::TimeType, null: false, description: "Time when this #{entity_name} was created"
      field :updated_at, Types::TimeType, null: false, description: "Time when this #{entity_name} was last updated"
    end

    def self.expose_abilities(abilities, entity_name: graphql_name, subject_resolver: nil)
      @user_ability_types ||= {}

      type_class = @user_ability_types.fetch("#{entity_name}UserAbilities", nil)
      already_exists = type_class.present?

      if type_class.nil?
        type_class = Class.new(BaseObject) do
          graphql_name "#{entity_name}UserAbilities"
          description "Abilities for the current user on this #{entity_name}"
        end

        @user_ability_types["#{entity_name}UserAbilities"] = type_class
      end

      type_class.class_eval do
        abilities.each do |ability|
          field ability, Boolean,
                null: false,
                description: "Shows if the current user has the `#{ability}` ability on this #{entity_name}"

          define_method(ability) do
            subject = subject_resolver.nil? ? object : subject_resolver.call
            Ability.allowed?(current_authentication, ability, subject)
          end
        end
      end

      return if already_exists

      field :user_abilities, type_class,
            null: false,
            description: "Abilities for the current user on this #{entity_name}"

      define_method(:user_abilities) { object || {} }
    end

    # Associations to batch-preload before this object's authorization runs, so
    # policy checks that walk them don't N+1. E.g. `authorization_preloads namespace: :namespace_members`.
    def self.authorization_preloads(*associations)
      if associations.any?
        @authorization_preloads = associations.freeze
      else
        @authorization_preloads ||
          (superclass.respond_to?(:authorization_preloads) ? superclass.authorization_preloads : [])
      end
    end

    def self.authorized?(object, context)
      if object.instance_variable_defined?(:@sagittarius_object_authorization_bypass)
        return object.instance_variable_get(:@sagittarius_object_authorization_bypass)
      end

      authorization_preloads.each do |association|
        context.dataloader.with(Sources::AssociationSource, association).load(object)
      end

      subject = object.try(:declarative_policy_subject) || @declarative_policy_subject.try(:call, object) || object

      authorize.all? do |ability|
        Ability.allowed?(context[:current_authentication], ability, subject)
      end
    end

    def self.authorize(*args)
      raise 'Cannot redefine authorize' if @authorize_args && args.any?

      @authorize_args = args.freeze if args.any?
      @authorize_args || (superclass.respond_to?(:authorize) ? superclass.authorize : [])
    end

    def self.declarative_policy_subject(&block)
      raise 'Cannot redefine declarative_policy_subject' if @declarative_policy_subject && block

      @declarative_policy_subject = block
    end

    def current_authentication
      context[:current_authentication]
    end

    # Batch-loads an association on this object via Sources::AssociationSource to avoid N+1.
    def preload(association)
      context.dataloader.with(Sources::AssociationSource, association).load(object)
    end
  end
end
