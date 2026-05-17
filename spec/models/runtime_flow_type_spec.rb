# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeFlowType do
  subject(:runtime_flow_type) { create(:runtime_flow_type) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime).inverse_of(:runtime_flow_types) }
    it { is_expected.to belong_to(:runtime_module).inverse_of(:runtime_flow_types) }
    it { is_expected.to have_many(:flow_types).inverse_of(:runtime_flow_type) }
    it { is_expected.to have_many(:runtime_flow_type_settings).inverse_of(:runtime_flow_type) }
    it { is_expected.to have_many(:runtime_flow_type_data_type_links).inverse_of(:runtime_flow_type) }

    it do
      is_expected.to have_many(:referenced_data_types)
        .through(:runtime_flow_type_data_type_links)
        .source(:referenced_data_type)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:identifier) }
    it { is_expected.to validate_uniqueness_of(:identifier).scoped_to(:runtime_id) }
    it { is_expected.to allow_values(true, false).for(:editable) }

    it { is_expected.to validate_presence_of(:signature) }
    it { is_expected.to validate_length_of(:signature).is_at_most(500) }

    it { is_expected.to validate_length_of(:definition_source).is_at_most(50) }
    it { is_expected.to validate_length_of(:display_icon).is_at_most(100) }
  end
end
