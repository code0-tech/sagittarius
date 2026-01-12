# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowTypeSetting do
  subject { create(:flow_type_setting) }

  describe 'associations' do
    it { is_expected.to belong_to(:flow_type).inverse_of(:flow_type_settings) }
    it { is_expected.to belong_to(:data_type) }
    it { is_expected.to have_many(:names).class_name('Translation') }
    it { is_expected.to have_many(:descriptions).class_name('Translation') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:identifier) }
    it { is_expected.to validate_uniqueness_of(:identifier).scoped_to(:flow_type_id) }
    it { is_expected.to allow_values(:none, :project, 'none', 'project').for(:unique) }
    it { is_expected.not_to allow_value(:unknown, 'unknown', 0).for(:unique) }
  end
end
