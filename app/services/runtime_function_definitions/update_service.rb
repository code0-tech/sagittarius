# frozen_string_literal: true

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
        runtime_function_definitions.each do |runtime_function_definition|
          unless update_runtime_function_definition(runtime_function_definition, t)
            t.rollback_and_return! ServiceResponse.error(message: 'Failed to update runtime function definition',
                                                         payload: runtime_function_definition.errors)
          end
        end

        ServiceResponse.success(message: 'Updated runtime function definition', payload: runtime_function_definitions)
      end
    end

    protected

    def update_runtime_function_definition(runtime_function_definition, t)
      db_object = RuntimeFunctionDefinition.find_or_initialize_by(namespace: current_runtime.namespace,
                                                                  runtime_name: runtime_function_definition.runtime_name)
      if runtime_function_definition.return_type_identifier.present?
        db_object.return_type = find_data_type(runtime_function_definition.return_type_identifier, t)
      else
        db_object.return_type = nil
      end
      db_object.parameters = update_parameters(runtime_function_definition.runtime_parameter_definitions, db_object.parameters, t)
      db_object.translations = update_translations(runtime_function_definition.name, db_object.translations)
      db_object.save
    end

    def find_data_type(identifier, t)
      data_type = DataType.find_by(namespace: [nil, current_runtime.namespace], identifier: identifier)

      if data_type.nil?
        t.rollback_and_return! ServiceResponse.error(message: "Could not find datatype with identifier #{identifier}",
                                                     payload: :no_datatype_for_identifier)
      end

      data_type
    end

    def update_parameters(parameters, db_parameters, t)
      db_parameters.each do |db_param|
        if parameters.find { |real_param| real_param.runtime_name == db_param.runtime_name }
          db_param.removed_at = nil
        else
          db_param.removed_at = Time.zone.now
        end
      end

      parameters.each do |real_param|
        db_param = db_parameters.find { |db_param| db_param.runtime_name == real_param.runtime_name }
        if db_param.nil?
          db_param = RuntimeParameterDefinition.new
          db_parameters << db_param
        end
        db_param.runtime_name = real_param.runtime_name
        db_param.datatype = find_data_type(real_param.data_type_identifier, t)
        db_param.translations = update_translations(real_param.name, db_param.translations)
      end

      db_parameters
    end

    def update_translations(real_translations, db_translations)
      db_translations = db_translations.first(real_translations.length)
      real_translations.each_with_index do |translation, index|
        db_translations[index] ||= Translation.new
        db_translations[index].assign_attributes(code: translation.code, content: translation.content)
      end

      db_translations
    end
  end
end
