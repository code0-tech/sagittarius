# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowTypeDataTypeLink do
  subject { create(:flow_type_data_type_link) }

  describe 'associations' do
    it { is_expected.to belong_to(:flow_type).inverse_of(:flow_type_data_type_links) }

    it { is_expected.to belong_to(:referenced_data_type).class_name('DataType') }
  end
end
