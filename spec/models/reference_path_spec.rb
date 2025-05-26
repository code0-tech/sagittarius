# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReferencePath do
  subject do
    create(:reference_path,
           reference_value: create(:reference_value,
                                   data_type_identifier: create(:data_type_identifier, data_type: create(:data_type))))
  end

  describe 'associations' do
    it { is_expected.to belong_to(:reference_value) }
  end
end
