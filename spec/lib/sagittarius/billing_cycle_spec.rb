# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sagittarius::BillingCycle do
  describe '.range_for' do
    it 'matches the 15th-to-15th example from the license billing cycle' do
      range = described_class.range_for(Date.new(2026, 1, 15), reference: Date.new(2026, 9, 16))

      expect(range).to eq(Date.new(2026, 9, 15)..Date.new(2026, 10, 14))
    end

    it 'uses the previous cycle when the reference date is before this month\'s anchor day' do
      range = described_class.range_for(Date.new(2026, 1, 15), reference: Date.new(2026, 9, 10))

      expect(range).to eq(Date.new(2026, 8, 15)..Date.new(2026, 9, 14))
    end

    it 'includes the reference date when it falls exactly on the anchor day' do
      range = described_class.range_for(Date.new(2026, 1, 15), reference: Date.new(2026, 9, 15))

      expect(range).to eq(Date.new(2026, 9, 15)..Date.new(2026, 10, 14))
    end

    it 'clamps a month-end anchor day to the shortest month in the cycle' do
      # Anchor day 31: the cycle that covers March 2026-03-15 started in February, which only
      # has 28 days in 2026, so it's clamped to the 28th (and the following cycle-end is
      # clamped the same way).
      range = described_class.range_for(Date.new(2026, 1, 31), reference: Date.new(2026, 3, 15))

      expect(range).to eq(Date.new(2026, 2, 28)..Date.new(2026, 3, 27))
    end
  end

  describe '.next_reset_date' do
    it 'is the day after the current cycle ends' do
      reset_date = described_class.next_reset_date(Date.new(2026, 1, 15), reference: Date.new(2026, 9, 16))

      expect(reset_date).to eq(Date.new(2026, 10, 15))
    end
  end
end
