# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowDataTypeLink do
  subject { create(:flow_data_type_link) }

  describe 'associations' do
    it { is_expected.to belong_to(:flow).inverse_of(:flow_data_type_links) }

    it { is_expected.to belong_to(:referenced_data_type).class_name('DataType') }
  end
end
