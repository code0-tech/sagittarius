# frozen_string_literal: true

module Runtimes
  module Grpc
    module DataTypeHelper
      # This method finds a DataType by its identifier within the current runtime.
      # @param identifier [String] The identifier of the DataType to find.
      # @param t [Object] The transaction context.
      def find_data_type(identifier, t)
        raise 'Including class must define current_runtime' unless respond_to?(:current_runtime)

        data_type = DataType.find_by(runtime: current_runtime, identifier: identifier)

        if data_type.nil?
          t.rollback_and_return! ServiceResponse.error(message: "Could not find datatype with identifier #{identifier}",
                                                       error_code: :no_data_type_for_identifier)
        end

        data_type
      end

      # This method links data types referenced by identifiers to the given record.
      # It re-uses existing link records and only creates new ones when needed.
      # @param record [ApplicationRecord] The record to link data types to.
      # @param identifiers [Array<String>] The list of data type identifiers to link.
      # @param t [Object] The transaction context.
      def link_data_types(record, identifiers, t)
        link_relation = record.public_send(:"#{record.class.name.underscore}_data_type_links")

        target_data_types = identifiers.map { |identifier| find_data_type(identifier, t) }
        target_ids = target_data_types.map(&:id)

        # Drop links that are no longer referenced BEFORE inserting, so a new link can never
        # transiently collide with a stale row on the unique (<record>_id, referenced_data_type_id)
        # index while the two sets overlap in a different order.
        link_relation.where.not(referenced_data_type_id: target_ids).delete_all

        existing_ids = link_relation.pluck(:referenced_data_type_id)

        target_data_types.each do |data_type|
          next if existing_ids.include?(data_type.id)

          link = link_relation.build(referenced_data_type: data_type)
          next if link.save

          t.rollback_and_return! ServiceResponse.error(
            message: "Could not link data type #{data_type.identifier}",
            error_code: :invalid_data_type_link,
            details: link.errors
          )
        end
      end
    end
  end
end
