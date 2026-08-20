# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeModuleDefinitionFlowTypeLink do
  subject { create(:runtime_module_definition_flow_type_link) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_module_definition).inverse_of(:runtime_module_definition_flow_type_links) }

    it { is_expected.to belong_to(:flow_type) }
  end
end
