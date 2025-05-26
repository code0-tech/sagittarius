# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReferenceValue do
  subject do
    create(:reference_value, data_type_identifier: create(:data_type_identifier, data_type: create(:data_type)))
  end

  describe 'associations' do
    it { is_expected.to belong_to(:data_type_identifier) }
    it { is_expected.to have_many(:reference_paths) }
  end
end
