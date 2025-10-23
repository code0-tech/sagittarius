# frozen_string_literal: true

module Runtimes
  module FlowTypes
    class UpdateService
      include Sagittarius::Database::Transactional

      attr_reader :current_runtime, :flow_types

      def initialize(current_runtime, flow_types)
        @current_runtime = current_runtime
        @flow_types = flow_types
      end

      def execute
        transactional do |t|
          # rubocop:disable Rails/SkipsModelValidations -- when marking definitions as removed, we don't care about validations
          FlowType.where(runtime: current_runtime).update_all(removed_at: Time.zone.now)
          # rubocop:enable Rails/SkipsModelValidations
          flow_types.each do |flow_type|
            unless update_flowtype(flow_type, t)
              t.rollback_and_return! ServiceResponse.error(message: 'Failed to update flow type',
                                                           payload: flow_type.errors)
            end
          end

          ServiceResponse.success(message: 'Updated data types', payload: flow_types)
        end
      end

      protected

      def update_flowtype(flow_type, t)
        db_object = FlowType.find_or_initialize_by(runtime: current_runtime, identifier: flow_type.identifier)
        db_object.removed_at = nil
        if flow_type.input_type_identifier.present?
          db_object.input_type = find_datatype(flow_type.input_type_identifier, t)
        end
        if flow_type.return_type_identifier.present?
          db_object.return_type = find_datatype(flow_type.return_type_identifier, t)
        end
        db_object.editable = flow_type.editable
        db_object.descriptions = update_translations(flow_type.description, db_object.descriptions)
        db_object.names = update_translations(flow_type.name, db_object.names)
        db_object.version = "#{flow_type.version.major}.#{flow_type.version.minor}.#{flow_type.version.patch}"
        db_object.save
      end

      def find_datatype(identifier, t)
        data_type = DataType.find_by(runtime: current_runtime, identifier: identifier)

        if data_type.nil?
          t.rollback_and_return! ServiceResponse.error(message: "Could not find datatype with identifier #{identifier}",
                                                       payload: :no_datatype_for_identifier)
        end

        data_type
      end

      def update_translations(translations, translation_relation)
        db_translations = translation_relation.first(translations.length)
        translations.each_with_index do |translation, index|
          db_translations[index] ||= translation_relation.build
          db_translations[index].assign_attributes(code: translation.code, content: translation.content)
        end

        db_translations
      end
    end
  end
end
