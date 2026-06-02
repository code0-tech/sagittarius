# frozen_string_literal: true

module Tooling
  module Graphql
    module Docs
      module Helper
        CONNECTION_ARGS = %w[after before first last].to_set

        def files
          rendering_objects.flat_map { |type, objects| Array(objects).map { |object| render(type, object) } }
        end

        def rendering_objects
          {
            scalar: parser.elements[:scalar],
            interface: parser.elements[:interface],
            union: parser.elements[:union],
            enum: parser.elements[:enum],
            object: parser.elements[:object],
            mutation: parser.elements[:mutation],
            subscription: parser.elements[:subscription],
            input_object: parser.elements[:input_object],
          }
        end

        def sorted_by_name(objects)
          return [] if objects.blank?

          objects.sort_by { |o| o[:name] }
        end

        def connection?(field)
          type_name = field.dig(:type, :name)
          type_name.present? && type_name.ends_with?('Connection')
        end

        def documented_arguments(field)
          args = field[:arguments]
          return [] if args.blank?
          return args unless connection?(field)

          args.reject { |arg| CONNECTION_ARGS.include?(arg[:name]) }
        end

        def arguments?(field)
          documented_arguments(field).present?
        end

        def render(type, object)
          filename = "#{type}/#{object[:name].downcase}.md"
          content = ERB.new(
            Rails.root.join('tooling/graphql/docs/templates', "#{type}.md.erb").read, trim_mode: '-'
          ).result_with_hash(
            object: object,
            sorted_by_name: method(:sorted_by_name),
            has_arguments: method(:arguments?),
            documented_arguments: method(:documented_arguments)
          )

          [filename, content]
        end
      end
    end
  end
end
