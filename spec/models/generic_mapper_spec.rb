# frozen_string_literal: true

# spec/models/generic_mapper_spec.rb
require 'rails_helper'

RSpec.describe GenericMapper do
  describe 'associations' do
    it { is_expected.to belong_to(:generic_type).optional }
    it { is_expected.to belong_to(:runtime) }
    it { is_expected.to belong_to(:source).class_name('DataTypeIdentifier') }
  end
end
