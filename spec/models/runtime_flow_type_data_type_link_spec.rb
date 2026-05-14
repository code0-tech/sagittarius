# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeFlowTypeDataTypeLink do
  subject { create(:runtime_flow_type_data_type_link) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_flow_type).inverse_of(:runtime_flow_type_data_type_links) }
    it { is_expected.to belong_to(:referenced_data_type).class_name('DataType') }
  end
end
