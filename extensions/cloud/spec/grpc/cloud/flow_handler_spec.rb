# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowHandler do
  describe '.no_active_license?' do
    it 'is always false, regardless of License state' do
      expect(described_class.no_active_license?).to be false
    end

    it 'stays false even when an EE License exists' do
      create(:license)

      expect(described_class.no_active_license?).to be false
    end
  end
end
