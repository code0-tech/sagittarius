# frozen_string_literal: true

class DataTypeIdentifiersFinder < ApplicationFinder
  def execute
    data_type_identifiers = base_scope
    data_type_identifiers = by_runtime(data_type_identifiers)
    data_type_identifiers = by_related_to_function_definition(data_type_identifiers)

    data_type_identifiers = add_related_identifiers(data_type_identifiers)

    super(data_type_identifiers)
  end

  private

  def base_scope
    DataTypeIdentifier.all
  end

  def by_runtime(data_type_identifiers)
    return data_type_identifiers unless params[:runtime]

    data_type_identifiers.where(runtime: params[:runtime])
  end

  def by_related_to_function_definition(data_type_identifiers)
    return data_type_identifiers unless params[:function_definition]

    data_type_identifiers
      .where(id: params[:function_definition].return_type_id)
      .or(data_type_identifiers.where(id: params[:function_definition].parameter_definitions.pluck(:data_type_id)))
  end

  def add_related_identifiers(data_type_identifiers)
    return data_type_identifiers unless params[:expand_recursively]

    sql = <<~SQL
      WITH RECURSIVE data_type_identifier_tree AS (
        -- Base case: starting identifiers
        SELECT *
        FROM data_type_identifiers
        WHERE id IN (?)

        UNION ALL

        -- Recursive case: find child identifiers
        SELECT dti.*
        FROM data_type_identifier_tree tree
          INNER JOIN generic_types gt
            ON tree.generic_type_id = gt.id
          INNER JOIN generic_mappers gm
            ON gt.id = gm.generic_type_id
          INNER JOIN data_type_identifiers dti
            ON dti.generic_mapper_id = gm.id
      )

      SELECT DISTINCT * FROM data_type_identifier_tree ORDER BY id
    SQL

    DataTypeIdentifier.find_by_sql([sql, data_type_identifiers.pluck(:id)])
  end
end
