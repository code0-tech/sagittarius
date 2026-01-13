# frozen_string_literal: true

class DataTypeIdentifiersFinder < ApplicationFinder
  def execute
    data_type_identifiers = base_scope
    data_type_identifiers = by_data_type(data_type_identifiers)
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

  def by_data_type(data_type_identifiers)
    return data_type_identifiers unless params[:data_type]

    dt = DataType.arel_table
    dtr = DataTypeRule.arel_table
    dti = DataTypeIdentifier.arel_table

    data_type_id_condition = case params[:data_type]
                             when DataType
                               dt[:id].eq(params[:data_type].id)
                             else
                               dt[:id].in(params[:data_type].pluck(:id))
                             end

    DataTypeIdentifier
      .from(dt)
      .joins(
        dt
          .join(dtr, Arel::Nodes::InnerJoin)
          .on(dt[:id].eq(dtr[:data_type_id]))
          .join(dti, Arel::Nodes::InnerJoin)
          .on(data_type_identifier_by_data_type_condition)
          .join_sources
      )
      .where(data_type_id_condition)
      .select(dti[Arel.star])
  end

  def add_related_identifiers(data_type_identifiers)
    return data_type_identifiers unless params[:expand_recursively]

    tree = Arel::Table.new(:data_type_identifier_tree)

    DataTypeIdentifier
      .with_recursive(data_type_identifier_tree: [
                        data_type_identifiers,
                        add_related_identifiers_recursive_case
                      ])
      .from(tree)
      .select(tree[Arel.star])
      .distinct
      .order(:id)
  end

  def add_related_identifiers_recursive_case
    tree = Arel::Table.new(:data_type_identifier_tree)
    dti = DataTypeIdentifier.arel_table
    dt = DataType.arel_table
    dtr = DataTypeRule.arel_table
    gt = GenericType.arel_table
    gm = GenericMapper.arel_table

    mapper_condition = dti[:generic_mapper_id].eq(gm[:id])

    join_condition = Arel::Nodes::Grouping.new(data_type_identifier_by_data_type_condition.or(mapper_condition))

    DataTypeIdentifier
      .from(tree)
      .joins(
        tree.join(dt, Arel::Nodes::OuterJoin)
            .on(tree[:data_type_id].eq(dt[:id]))
            .join(dtr, Arel::Nodes::OuterJoin)
            .on(dt[:id].eq(dtr[:data_type_id]))
            .join(gt, Arel::Nodes::OuterJoin)
            .on(tree[:generic_type_id].eq(gt[:id]))
            .join(gm, Arel::Nodes::OuterJoin)
            .on(gt[:id].eq(gm[:generic_type_id]))
            .join(dti, Arel::Nodes::InnerJoin)
            .on(join_condition)
            .join_sources
      )
      .select(dti[Arel.star])
  end

  def data_type_identifier_by_data_type_condition
    dt = DataType.arel_table
    dti = DataTypeIdentifier.arel_table
    dtr = DataTypeRule.arel_table

    basic_rule_condition = dti[:id].eq(
      Arel::Nodes::NamedFunction.new(
        'CAST',
        [
          Arel::Nodes::As.new(
            Arel::Nodes::InfixOperation.new('->', dtr[:config], Arel::Nodes.build_quoted('data_type_identifier_id')),
            Arel::Nodes::SqlLiteral.new('BIGINT')
          )
        ]
      )
    )

    input_types_any_condition = Arel::Nodes::NamedFunction.new(
      'ANY',
      [
        Arel::Nodes::NamedFunction.new(
          'ARRAY', [
            Arel::Nodes::SqlLiteral.new(
              <<~SQL.squish
                SELECT elem::BIGINT
                FROM JSONB_ARRAY_ELEMENTS_TEXT(
                  JSONB_PATH_QUERY_ARRAY(data_type_rules.config, '$.input_types[*].data_type_identifier_id')
                ) elem
            SQL
            )
          ]
        )
      ]
    )

    input_types_rule_condition = dti[:id].eq(input_types_any_condition)

    parent_type_condition = dt[:parent_type_id].eq(dti[:id])

    Arel::Nodes::Grouping.new(
      basic_rule_condition.or(input_types_rule_condition).or(parent_type_condition)
    )
  end
end
