# frozen_string_literal: true

# spec/models/generic_type_spec.rb
require 'rails_helper'

RSpec.describe GenericType do
  describe 'associations' do
    it { is_expected.to belong_to(:data_type) }
    it { is_expected.to have_many(:generic_mappers) }
  end
end
