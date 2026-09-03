# frozen_string_literal: true

class AddFunctionDefinitionToParameterDefinition < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    # rubocop:disable-next Rails/NotNullColumn -- backwards compatibility intentionally ignored
    add_reference :parameter_definitions, :function_definition, null: false, foreign_key: { on_delete: :cascade }
  end
end
