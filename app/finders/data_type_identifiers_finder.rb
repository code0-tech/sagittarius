# frozen_string_literal: true

class DataTypeIdentifiersFinder < ApplicationFinder
  def execute
    data_type_identifiers = base_scope
    data_type_identifiers = by_runtime(data_type_identifiers)
    data_type_identifiers = by_related_to_function_definition(data_type_identifiers)

    data_type_identifiers = add_related_identifiers(data_type_identifiers, add_related_identifiers_generics_case)

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

  def add_related_identifiers(data_type_identifiers, recursive_query_case)
    return data_type_identifiers unless params[:expand_recursively]

    tree = Arel::Table.new(:data_type_identifier_tree)

    DataTypeIdentifier
      .with_recursive(data_type_identifier_tree: [
                        data_type_identifiers,
                        recursive_query_case
                      ])
      .from(tree)
      .select(tree[Arel.star])
      .distinct
      .order(:id)
  end

  def add_related_identifiers_generics_case
    tree = Arel::Table.new(:data_type_identifier_tree)
    dti = DataTypeIdentifier.arel_table
    gt = GenericType.arel_table
    gm = GenericMapper.arel_table

    DataTypeIdentifier
      .from(tree)
      .joins(
        tree.join(gt, Arel::Nodes::InnerJoin)
            .on(tree[:generic_type_id].eq(gt[:id]))
            .join(gm, Arel::Nodes::InnerJoin)
            .on(gt[:id].eq(gm[:generic_type_id]))
            .join(dti, Arel::Nodes::InnerJoin)
            .on(dti[:generic_mapper_id].eq(gm[:id]))
            .join_sources
      )
      .select(dti[Arel.star])
  end
end
