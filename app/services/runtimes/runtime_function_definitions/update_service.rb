# frozen_string_literal: true

module Runtimes
  module RuntimeFunctionDefinitions
    class UpdateService
      include Sagittarius::Database::Transactional

      attr_reader :current_runtime, :runtime_function_definitions

      def initialize(current_runtime, runtime_function_definitions)
        @current_runtime = current_runtime
        @runtime_function_definitions = runtime_function_definitions
      end

      def execute
        transactional do |t|
          # rubocop:disable Rails/SkipsModelValidations -- when marking definitions as removed, we don't care about validations
          RuntimeFunctionDefinition.where(runtime: current_runtime).update_all(removed_at: Time.zone.now)
          # rubocop:enable Rails/SkipsModelValidations
          runtime_function_definitions.each do |runtime_function_definition|
            response = update_runtime_function_definition(runtime_function_definition, t)
            unless response.persisted?
              t.rollback_and_return! ServiceResponse.error(message: 'Failed to update runtime function definition',
                                                           payload: response.errors)
            end
          end

          ServiceResponse.success(message: 'Updated runtime function definition', payload: runtime_function_definitions)
        end
      end

      protected

      def update_runtime_function_definition(runtime_function_definition, t)
        db_object = RuntimeFunctionDefinition.find_or_initialize_by(
          runtime: current_runtime,
          runtime_name: runtime_function_definition.runtime_name
        )
        db_object.removed_at = nil
        db_object.return_type = if runtime_function_definition.return_type_identifier.present?
                                  find_data_type(runtime_function_definition.return_type_identifier, t)
                                end
        db_object.parameters = update_parameters(runtime_function_definition.runtime_parameter_definitions,
                                                 db_object.parameters, t)
        db_object.names = update_translations(runtime_function_definition.name, db_object.names)
        db_object.descriptions = update_translations(runtime_function_definition.description, db_object.descriptions)
        db_object.documentations = update_translations(runtime_function_definition.documentation,
                                                       db_object.documentations)
        db_object.deprecation_messages = update_translations(runtime_function_definition.deprecation_message,
                                                             db_object.deprecation_messages)

        db_object.error_types = update_error_types(runtime_function_definition.error_type_identifiers, db_object, t)

        if db_object.function_definitions.empty?
          definition = FunctionDefinition.new
          definition.names = update_translations(runtime_function_definition.name, definition.names)
          definition.descriptions = update_translations(runtime_function_definition.description,
                                                        definition.descriptions)
          definition.documentations = update_translations(runtime_function_definition.documentation,
                                                          definition.documentations)
          definition.return_type = db_object.return_type

          db_object.function_definitions << definition
        end
        db_object.save
        db_object
      end

      def find_data_type(identifier, t)
        data_type = DataType.find_by(runtime: current_runtime, identifier: identifier)

        if data_type.nil?
          t.rollback_and_return! ServiceResponse.error(message: "Could not find datatype with identifier #{identifier}",
                                                       payload: :no_datatype_for_identifier)
        end

        data_type
      end

      def update_parameters(parameters, db_parameters, t)
        # rubocop:disable Rails/SkipsModelValidations -- when marking definitions as removed, we don't care about validations
        db_parameters.update_all(removed_at: Time.zone.now)
        # rubocop:enable Rails/SkipsModelValidations

        parameters.each do |real_param|
          db_param = db_parameters.find { |current_param| current_param.runtime_name == real_param.runtime_name }
          if db_param.nil?
            db_param = RuntimeParameterDefinition.new
            db_parameters << db_param
          end
          db_param.runtime_name = real_param.runtime_name
          db_param.removed_at = nil
          db_param.data_type = find_data_type(real_param.data_type_identifier, t)

          db_param.names = update_translations(real_param.name, db_param.names)
          db_param.descriptions = update_translations(real_param.description, db_param.descriptions)
          db_param.documentations = update_translations(real_param.documentation, db_param.documentations)

          db_param.default_value = real_param.default_value&.to_ruby(true)

          next unless db_param.parameter_definitions.empty?

          definition = ParameterDefinition.new
          definition.names = update_translations(real_param.name, definition.names)
          definition.descriptions = update_translations(real_param.description, definition.descriptions)
          definition.documentations = update_translations(real_param.documentation, definition.documentations)
          definition.data_type = db_param.data_type
          definition.default_value = db_param.default_value

          db_param.parameter_definitions << definition
        end

        db_parameters
      end

      def update_translations(real_translations, translation_relation)
        db_translations = translation_relation.first(real_translations.length)
        real_translations.each_with_index do |translation, index|
          db_translations[index] ||= translation_relation.build
          db_translations[index].assign_attributes(code: translation.code, content: translation.content)
        end

        db_translations
      end

      def update_error_types(real_error_type_identifiers, runtime_function_definition, t)
        db_error_types = runtime_function_definition.error_types.first(real_error_type_identifiers.length)
        real_error_type_identifiers.each_with_index do |error_type_identifier, index|
          db_error_types[index] ||= runtime_function_definition.error_types.build
          db_error_types[index].data_type = find_data_type(error_type_identifier, t)
        end

        db_error_types
      end
    end
  end
end
