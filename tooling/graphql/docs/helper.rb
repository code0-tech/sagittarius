# frozen_string_literal: true

module Tooling
  module Graphql
    module Docs
      ViolatedAssumption = Class.new(StandardError)
      CONNECTION_ARGS = %w[after before first last].to_set

      # rubocop:disable Metrics/ModuleLength
      module Helper # rubocop:disable GraphQL/ObjectDescription -- this is not a graphql object
        include GraphQLDocs::Helpers

        def files
          rendering_objects.flat_map { |type, objects| objects.map { |object| render(type, object) } }
        end

        def rendering_objects
          {
            object: object_types + operation_types.select { |t| t[:name] == 'Query' },
            scalar: scalar_types,
            interface: interfaces,
            union: union_types,
            mutation: mutations,
            enum: enums,
          }
        end

        def mutations
          graphql_mutation_types.map do |t|
            inputs = t[:input_fields]
            input = inputs.first
            name = t[:name]

            assert!(inputs.one?, "Expected exactly 1 input field named #{name}. Found #{inputs.count} instead.")
            assert!(input[:name] == 'input', "Expected the input of #{name} to be named 'input'")

            input_type_name = input[:type][:name]
            input_type = graphql_input_object_types.find { |type| type[:name] == input_type_name }
            assert!(input_type.present?, "Cannot find #{input_type_name} for #{name}.input")

            arguments = input_type[:input_fields]
            t.merge(
              arguments: arguments,
              markdown_documentation: schema.mutation.fields[t[:name]].mutation.try(:markdown_documentation).try(:strip)
            )
          end
        end

        def enums
          graphql_enum_types
            .reject { |type| type[:values].empty? }
            .reject { |enum_type| enum_type[:name].start_with?('__') }
            .map do |type|
              type.merge(
                values: sorted_by_name(type[:values]),
                markdown_documentation: schema.types[type[:name]].try(:markdown_documentation).try(:strip)
              )
            end
        end

        def operation_types
          graphql_operation_types.map do |type|
            type.merge(markdown_documentation: schema.types[type[:name]].try(:markdown_documentation).try(:strip))
          end
        end

        def scalar_types
          graphql_scalar_types.map do |type|
            type.merge(markdown_documentation: schema.types[type[:name]].try(:markdown_documentation).try(:strip))
          end
        end

        def union_types
          graphql_union_types.map do |type|
            type.merge(markdown_documentation: schema.types[type[:name]].try(:markdown_documentation).try(:strip))
          end
        end

        def object_types
          objects.reject { |t| t[:is_payload] }
        end

        def interfaces
          graphql_interface_types.map do |t|
            t.merge(
              fields: t[:fields] + t[:connections],
              markdown_documentation: schema.types[t[:name]].try(:markdown_documentation).try(:strip)
            )
          end
        end

        def sorted_by_name(objects)
          return [] if objects.blank?

          objects.sort_by { |o| o[:name] }
        end

        def connection?(field)
          type_name = field.dig(:type, :name)
          type_name.present? && type_name.ends_with?('Connection')
        end

        # rubocop:disable Metrics/CyclomaticComplexity
        # rubocop:disable Metrics/PerceivedComplexity
        def objects
          mutations = schema.mutation&.fields&.keys&.to_set || []

          graphql_object_types
            .reject { |object_type| object_type[:name]['__'] || object_type[:name] == 'Subscription' }
            .map do |type|
            name = type[:name]
            type.merge(
              is_edge: name.end_with?('Edge'),
              is_connection: name.end_with?('Connection'),
              is_payload: name.end_with?('Payload') && mutations.include?(name.chomp('Payload').camelcase(:lower)),
              fields: type[:fields] + type[:connections],
              markdown_documentation: schema.types[name].try(:markdown_documentation).try(:strip)
            )
          end
        end
        # rubocop:enable Metrics/PerceivedComplexity
        # rubocop:enable Metrics/CyclomaticComplexity

        def arguments?(field)
          args = field[:arguments]
          return false if args.blank?
          return true unless connection?(field)

          args.any? { |arg| CONNECTION_ARGS.exclude?(arg[:name]) }
        end

        def render(type, object)
          filename = "#{type}/#{object[:name].downcase}.md"
          content = ERB.new(
            Rails.root.join('tooling/graphql/docs/templates', "#{type}.md.erb").read, trim_mode: '-'
          ).result_with_hash(
            object: object,
            sorted_by_name: method(:sorted_by_name),
            has_arguments: method(:arguments?)
          )

          [filename, content]
        end

        def assert!(claim, message)
          raise ViolatedAssumption, "#{message}\nThis violation should not have happened" unless claim
        end
      end
      # rubocop:enable Metrics/ModuleLength
    end
  end
end
