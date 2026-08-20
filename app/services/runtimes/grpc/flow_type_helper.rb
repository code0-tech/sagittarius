# frozen_string_literal: true

module Runtimes
  module Grpc
    module FlowTypeHelper
      # This method finds a FlowType by its identifier within the current runtime.
      # @param identifier [String] The identifier of the FlowType to find.
      # @param t [Object] The transaction context.
      def find_flow_type(identifier, t)
        raise 'Including class must define current_runtime' unless respond_to?(:current_runtime)

        flow_type = FlowType.find_by(runtime: current_runtime, identifier: identifier)

        if flow_type.nil?
          t.rollback_and_return! ServiceResponse.error(
            message: "Could not find flow type with identifier #{identifier}",
            error_code: :no_flow_type_for_identifier
          )
        end

        flow_type
      end

      # This method links flow types referenced by identifiers to the given record.
      # It re-uses existing link records and only creates new ones when needed.
      # @param record [ApplicationRecord] The record to link flow types to.
      # @param identifiers [Array<String>] The list of flow type identifiers to link.
      # @param t [Object] The transaction context.
      def link_flow_types(record, identifiers, t)
        link_relation = record.public_send(:"#{record.class.name.underscore}_flow_type_links")
        db_links = link_relation.first(identifiers.length)

        identifiers.each_with_index do |identifier, index|
          db_links[index] ||= link_relation.build
          db_links[index].flow_type = find_flow_type(identifier, t)

          next if db_links[index].save

          t.rollback_and_return! ServiceResponse.error(
            message: "Could not link flow type #{identifier}",
            error_code: :invalid_flow_type_link,
            details: db_links[index].errors
          )
        end

        link_relation.where.not(id: db_links.map(&:id)).delete_all
      end
    end
  end
end
