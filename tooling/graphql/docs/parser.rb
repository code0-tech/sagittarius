# frozen_string_literal: true

module Tooling
  module Graphql
    module Docs
      class Parser # rubocop:disable GraphQL/ObjectDescription -- this is not a graphql object
        ViolatedAssumption = Class.new(StandardError)
        SLUGIFY_PRETTY_REGEXP = Regexp.new("[^[:alnum:]._~!$&'()+,;=@]+").freeze

        attr_reader :schema, :elements

        def initialize(schema)
          @schema = schema
          @elements = {}
        end

        def parse
          schema.types.each_value do |type|
            element = {
              name: type.graphql_name,
              description: type.description,
              markdown_documentation: type.try(:markdown_documentation).try(:strip),
            }
            parse_type_specific(type, element)
            elements[element[:type].to_sym] ||= []
            elements[element[:type].to_sym] << element
          end

          process_interfaces
          process_mutations
          reject_types
        end

        def reject_types
          elements.each_pair do |type, e|
            e.reject! do |element|
              name = element[:name]
              next true if name.start_with?('__')
              next true if type == :object && name == 'Mutation'

              name.end_with?('Payload') && elements[:mutation].find do |mutation|
                mutation[:name] == name.chomp('Payload').camelcase(:lower)
              end
            end
          end
        end

        def process_interfaces
          elements[:interface].each do |interface|
            interface[:implemented_by] = elements[:object]
                                         .filter { |object| object[:interfaces]&.include?(interface[:name]) }
                                         .pluck(:name)
          end
        end

        def process_mutations
          mutations = elements[:object].find { |obj| obj[:name] == 'Mutation' }[:fields]

          mutations.each do |mutation|
            inputs = mutation[:arguments]
            input = inputs.first
            assert!(inputs.one?, "Expected exactly 1 input field. Found #{inputs.count} instead.")
            assert!(input[:name] == 'input', "Expected the input of #{mutation[:name]} to be named 'input'.")

            input_object = elements[:input_object].find { |type| type[:name] == input[:type][:name] }
            assert!(input_object.present?, "Cannot find #{input[:type][:name]} for #{mutation[:name]}.input")

            payload_object = elements[:object].find { |type| type[:name] == mutation[:type][:name] }
            assert!(payload_object.present?, "Cannot find #{mutation[:type][:name]} as payload for #{mutation[:name]}")

            mutation[:arguments] = input_object[:input_fields]
            mutation[:fields] = payload_object[:fields]
          end

          elements[:mutation] = mutations
        end

        def parse_type_specific(type, element)
          if type < ::GraphQL::Schema::Object
            element[:fields] = build_fields(type.fields)
            element[:type] = 'object'
          elsif type < ::GraphQL::Schema::Interface
            element[:fields] = build_fields(type.fields)
            element[:type] = 'interface'
          elsif type < ::GraphQL::Schema::Enum
            element[:values] = type.values.values.map do |val|
              data = {}
              data[:name] = val.graphql_name
              data[:description] = val.description
              unless val.deprecation_reason.nil?
                data[:is_deprecated] = true
                data[:deprecation_reason] = val.deprecation_reason
              end
              data
            end
            element[:type] = 'enum'
          elsif type < ::GraphQL::Schema::Union
            element[:possible_types] = type.possible_types.map(&:graphql_name).sort
            element[:type] = 'union'
          elsif type < ::GraphQL::Schema::InputObject
            element[:input_fields] = build_fields(type.arguments)
            element[:type] = 'input_object'
          elsif type < ::GraphQL::Schema::Scalar
            element[:type] = 'scalar'
          end
        end

        def build_fields(object_fields)
          fields = []

          object_fields.each_value do |field|
            data = {
              name: field.graphql_name,
              description: field.description,
              type: build_type(field.type),
              arguments: [],
            }

            if field.respond_to?(:deprecation_reason) && !field.deprecation_reason.nil?
              data[:deprecated] = true
              data[:deprecation_reason] = field.deprecation_reason
            end

            if field.respond_to?(:arguments)
              field.arguments.each_value { |argument| data[:arguments] << build_argument(argument) }
            end

            fields << data
          end

          fields
        end

        def build_type(type)
          name = type.unwrap.graphql_name

          path = if type.unwrap < GraphQL::Schema::Object
                   'object'
                 elsif type.unwrap < GraphQL::Schema::Scalar
                   'scalar'
                 elsif type.unwrap < GraphQL::Schema::Interface
                   'interface'
                 elsif type.unwrap < GraphQL::Schema::Enum
                   'enum'
                 elsif type.unwrap < GraphQL::Schema::InputObject
                   'input_object'
                 elsif type.unwrap < GraphQL::Schema::Union
                   'union'
                 else
                   raise TypeError, "Unknown type for `#{name}`: `#{type.unwrap.class}`"
                 end

          {
            name: name,
            path: "#{path}/#{slugify(name)}",
            info: type.to_type_signature,
          }
        end

        def build_argument(argument)
          data = {
            name: argument.graphql_name,
            description: argument.description,
            type: build_type(argument.type),
          }

          data[:default_value] = argument.default_value if argument.default_value?

          if argument.respond_to?(:deprecation_reason) && argument.deprecation_reason
            data[:deprecated] = true
            data[:deprecation_reason] = argument.deprecation_reason
          end

          data
        end

        def argument?(field)
          field.is_a?(::GraphQL::Schema::Argument)
        end

        def connection?(field)
          field.respond_to?(:connection?) && field.connection?
        end

        def slugify(str)
          slug = str.gsub(SLUGIFY_PRETTY_REGEXP, '-')
          slug.gsub!(/^-|-$/i, '')
          slug.downcase
        end

        def assert!(claim, message)
          raise ViolatedAssumption, "#{message}\nThis violation should not have happened" unless claim
        end
      end
    end
  end
end
