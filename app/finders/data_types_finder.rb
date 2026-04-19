# frozen_string_literal: true

class DataTypesFinder < ApplicationFinder
  def execute
    data_types = base_scope
    data_types = by_data_type(data_types)
    data_types = by_runtime_function_definition(data_types)
    data_types = by_function_definition(data_types)
    data_types = by_flow_type(data_types)
    data_types = by_flow(data_types)

    data_types = add_related_data_types(data_types)

    super(data_types)
  end

  private

  def base_scope
    DataType.all
  end

  def by_data_type(data_types)
    return data_types unless params[:data_type]

    data_types.where(id: params[:data_type].referenced_data_types.pluck(:id))
  end

  def by_runtime_function_definition(data_types)
    return data_types unless params[:runtime_function_definition]

    referenced_data_types_ids = RuntimeFunctionDefinitionDataTypeLink
                                .where(runtime_function_definition: params[:runtime_function_definition])
                                .select(:referenced_data_type_id)

    data_types.where(id: referenced_data_types_ids)
  end

  def by_function_definition(data_types)
    return data_types unless params[:function_definition]

    referenced_data_types_ids = FunctionDefinitionDataTypeLink
                                .where(function_definition: params[:function_definition])
                                .select(:referenced_data_type_id)

    data_types.where(id: referenced_data_types_ids)
  end

  def by_flow_type(data_types)
    return data_types unless params[:flow_type]

    data_types.where(id: params[:flow_type].referenced_data_types.pluck(:id))
  end

  def by_flow(data_types)
    return data_types unless params[:flow]

    data_types.where(id: params[:flow].referenced_data_types.pluck(:id))
  end

  def add_related_data_types(data_types)
    return data_types unless params[:expand_recursively]

    tree = Arel::Table.new(:data_type_tree)

    DataType
      .with_recursive(data_type_tree: [
                        data_types,
                        add_related_data_types_recursive_case
                      ])
      .from(tree)
      .select(tree[Arel.star])
      .distinct
      .order(:id)
  end

  def add_related_data_types_recursive_case
    tree = Arel::Table.new(:data_type_tree)
    dt = DataType.arel_table
    link = DataTypeDataTypeLink.arel_table

    DataType
      .from(tree)
      .joins(
        tree.join(link, Arel::Nodes::InnerJoin)
            .on(tree[:id].eq(link[:data_type_id]))
            .join(dt, Arel::Nodes::InnerJoin)
            .on(link[:referenced_data_type_id].eq(dt[:id]))
            .join_sources
      )
      .select(dt[Arel.star])
  end
end
