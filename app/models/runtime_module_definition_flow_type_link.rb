# frozen_string_literal: true

class RuntimeModuleDefinitionFlowTypeLink < ApplicationRecord
  belongs_to :runtime_module_definition, inverse_of: :runtime_module_definition_flow_type_links
  belongs_to :flow_type
end
