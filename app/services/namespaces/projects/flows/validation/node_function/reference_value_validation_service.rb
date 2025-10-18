# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        module NodeFunction
          class ReferenceValueValidationService
            include Code0::ZeroTrack::Loggable
            include Sagittarius::Database::Transactional

            attr_reader :current_authentication, :flow, :node, :reference_value

            def initialize(current_authentication, flow, node, reference_value)
              @current_authentication = current_authentication
              @flow = flow
              @node = node
              @reference_value = reference_value
            end

            def find_primary_nodes(search_node, curr_primary, primary_level)
              found_node = nil
              search_node.node_parameters.each do |param|
                next if param.function_value.blank?

                curr_primary += 1
                if curr_primary == primary_level
                  found_node = param.function_value
                  break
                end
                find_node = find_primary_nodes(param.function_value, curr_primary, primary_level)
                found_node = find_node[:found_node]
                break if found_node.present?
              end
              {
                found_node: found_node,
                new_primary: curr_primary,
              }
            end

            def execute
              errors = []
              errors += Namespaces::Projects::Flows::Validation::DataType::DataTypeIdentifierValidationService.new(
                current_authentication,
                flow,
                node,
                reference_value.data_type_identifier
              ).execute

              primary_level = reference_value.primary_level
              curr_primary = 0
              node = flow.starting_node

              while curr_primary < primary_level
                if node.nil?
                  errors << ValidationResult.error(:primary_level_not_found)
                  return errors
                end
                nodes = find_primary_nodes(node, curr_primary, primary_level)
                if nodes[:found_node].nil?
                  curr_primary = nodes[:new_primary]
                else
                  node = nodes[:found_node]
                  break
                end

                next_node = node.next_node
                node = next_node
              end

              secondary_level = reference_value.secondary_level

              curr_secondary = 0

              while curr_secondary != secondary_level
                errors << ValidationResult.error(:secondary_level_not_found) if node.next_node.nil?
                next_node = node.next_node
                node = next_node

                curr_secondary += 1
              end

              return errors if reference_value.tertiary_level.nil?

              tertiary_level = reference_value.tertiary_level

              if tertiary_level >= node.node_parameters.count
                errors << ValidationResult.error(:tertiary_level_exceeds_parameters)
              end
              # https://github.com/code0-tech/sagittarius/issues/508 Validate the usage and datatypes
              errors
            end
          end
        end
      end
    end
  end
end
