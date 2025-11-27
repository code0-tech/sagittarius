# frozen_string_literal: true

module Runtimes
  module Grpc
    module DataTypeHelper
      # This method updates or creates GenericMappers based on the provided gRPC GenericMapper objects
      # within the current runtime.
      # @param generic_mappers [Array<Tucana::Shared::GenericMapper>] An array of gRPC GenericMapper objects.
      def update_mappers(generic_mappers, t)
        raise 'Including class must define current_runtime' unless respond_to?(:current_runtime)

        generic_mappers.to_a.map do |generic_mapper|
          if generic_mapper.is_a? Tucana::Shared::GenericMapper
            mapper = GenericMapper.create_or_find_by(runtime: current_runtime,
                                                     target: generic_mapper.target,
                                                     sources: generic_mapper.source.map do |source|
                                                       find_data_type_identifier(source, t)
                                                     end)
          end

          if mapper.nil? || !mapper.save
            t.rollback_and_return! ServiceResponse.error(
              message: "Could not find or create generic mapper (#{generic_mapper})",
              error_code: :invalid_generic_mapper
            )
          end
          mapper
        end
      end

      # This method finds or creates a DataTypeIdentifier based on the provided identifier within the current runtime.
      # @param identifier [Tucana::Sagittarius::DataTypeIdentifier] The gRPC DataTypeIdentifier object.
      def find_data_type_identifier(identifier, t)
        if identifier.data_type_identifier.present?
          return create_data_type_identifier(t, data_type_id: find_data_type(identifier.data_type_identifier, t).id)
        end

        if identifier.generic_type.present?
          data_type = find_data_type(identifier.generic_type.data_type_identifier, t)

          generic_type = GenericType.find_by(
            data_type: data_type
          )
          if generic_type.nil?
            generic_type = GenericType.create(
              data_type: data_type
            )
          end

          if generic_type.nil?
            t.rollback_and_return! ServiceResponse.error(
              message: "Could not find generic type with identifier #{identifier.generic_type.data_type_identifier}",
              error_code: :no_generic_type_for_identifier
            )
          end

          generic_type.assign_attributes(generic_mappers: update_mappers(identifier.generic_type.generic_mappers,
                                                                         t))

          return create_data_type_identifier(t, generic_type_id: generic_type.id)
        end

        return create_data_type_identifier(t, generic_key: identifier.generic_key) if identifier.generic_key.present?

        raise ArgumentError, "Invalid identifier: #{identifier.inspect}"
      end

      # This method creates or finds a DataTypeIdentifier based on the provided keyword arguments
      # within the current runtime.
      # It also handles transaction rollback in case of failure.
      # @param t [ActiveRecord::Connection] The database transaction context.
      # @param kwargs [Hash] The attributes to find or create the DataTypeIdentifier.
      def create_data_type_identifier(t, **kwargs)
        raise 'Including class must define current_runtime' unless respond_to?(:current_runtime)

        data_type_identifier = DataTypeIdentifier.find_by(runtime_id: current_runtime.id, **kwargs)
        if data_type_identifier.nil?
          data_type_identifier = DataTypeIdentifier.create_or_find_by(runtime_id: current_runtime.id, **kwargs)
        end

        if data_type_identifier.nil?
          t.rollback_and_return! ServiceResponse.error(
            message: "Could not find datatype identifier with #{kwargs}",
            error_code: :no_datatype_identifier_for_generic_key
          )
        end

        data_type_identifier
      end

      # This method finds a DataType by its identifier within the current runtime.
      # @param identifier [String] The identifier of the DataType to find.
      def find_data_type(identifier, t)
        raise 'Including class must define current_runtime' unless respond_to?(:current_runtime)

        data_type = DataType.find_by(runtime: current_runtime, identifier: identifier)

        if data_type.nil?
          t.rollback_and_return! ServiceResponse.error(message: "Could not find datatype with identifier #{identifier}",
                                                       error_code: :no_datatype_for_identifier)
        end

        data_type
      end
    end
  end
end
