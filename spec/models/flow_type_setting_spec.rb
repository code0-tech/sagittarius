# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowTypeSetting do
  subject { create(:flow_type_setting) }

  describe 'associations' do
    it { is_expected.to belong_to(:flow_type).inverse_of(:flow_type_settings) }
    it { is_expected.to have_many(:names).class_name('Translation') }
    it { is_expected.to have_many(:descriptions).class_name('Translation') }

    it { is_expected.to have_many(:flow_type_setting_data_type_links).inverse_of(:flow_type_setting) }

    it do
      is_expected.to have_many(:referenced_data_types)
        .through(:flow_type_setting_data_type_links)
        .source(:referenced_data_type)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:identifier) }
    it { is_expected.to validate_uniqueness_of(:identifier).scoped_to(:flow_type_id) }
    it { is_expected.to allow_values(:none, :project, 'none', 'project').for(:unique) }
    it { is_expected.not_to allow_value(:unknown, 'unknown', 0).for(:unique) }

    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_length_of(:type).is_at_most(2000) }
  end
end
