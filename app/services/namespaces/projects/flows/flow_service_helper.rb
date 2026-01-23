# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module FlowServiceHelper
        def get_data_type_identifier(runtime, identifier, t)
          if identifier.generic_key.present?
            return DataTypeIdentifier.find_or_create_by(runtime: runtime,
                                                        generic_key: identifier.generic_key)
          end

          if identifier.generic_type.present?
            data_type = runtime.data_types.find_by(
              id: identifier.generic_type.data_type_id.model_id
            )

            if data_type.nil?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Data type not found',
                error_code: :data_type_not_found
              )
            end

            mappers = identifier.generic_type.mappers.map do |mapper|
              GenericMapper.find_or_create_by(
                runtime: runtime,
                generic_mapper_id: mapper.generic_mapper_id,
                source: mapper.source,
                target: mapper.target
              )
            end
            generic_type = GenericType.joins(:generic_mappers).find_or_create_by(data_type: data_type,
                                                                                 generic_mappers: mappers)
            return DataTypeIdentifier.find_or_create_by(runtime: runtime, generic_type: generic_type)
          end

          data_type = runtime.data_types.find_by(id: identifier.data_type_id.model_id)

          if data_type.nil?
            t.rollback_and_return! ServiceResponse.error(
              message: 'Data type not found',
              error_code: :data_type_not_found
            )
          end

          DataTypeIdentifier.find_or_create_by(runtime: runtime, data_type: data_type)
        end
      end
    end
  end
end
