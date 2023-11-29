# frozen_string_literal: true

module Types
  class GlobalIdType < BaseScalar
    graphql_name 'GlobalID'
    description 'A global identifier for an entity'

    def self.coerce_input(input_value, _context)
      GlobalID.parse(input_value)
    end

    def self.coerce_result(value, _context)
      value.to_global_id.to_s
    end

    def self.[](model_class)
      @id_types ||= {}
      @id_types[model_class] ||= Class.new(self) do
        model_name = model_class.name
        graphql_name model_name_to_graphql_name(model_name)
        description "A unique identifier for all #{model_name} entities of the application"

        define_singleton_method(:to_s) { graphql_name }
        define_singleton_method(:inspect) { graphql_name }

        define_singleton_method(:coerce_result) do |gid, _context|
          next gid.to_s if suitable?(gid)

          raise GraphQL::CoercionError, "Expected a #{model_name} ID, got #{gid}"
        end

        define_singleton_method(:coerce_input) do |string, context|
          gid = super(string, context)
          next gid if suitable?(gid)

          raise GraphQL::CoercionError, "#{string.inspect} does not represent an instance of #{model_name}"
        end

        define_singleton_method(:suitable?) do |gid|
          next true if gid.nil?

          gid.model_name.safe_constantize.present? &&
            gid.model_class.ancestors.include?(model_class)
        end
      end
    end

    def self.model_name_to_graphql_name(model_name)
      "#{model_name.gsub('::', '')}ID"
    end
  end
end
