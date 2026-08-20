# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::Concerns::HasUsageField do
  describe '.validate_range!' do
    it 'raises when the range is shorter than the allowed 7-31 day span' do
      expect do
        described_class.validate_range!(aggregation: 'day', after_date: Date.new(2026, 8, 1),
                                        before_date: Date.new(2026, 8, 3))
      end.to raise_error(GraphQL::ExecutionError, /must span between 7 and 31/)
    end

    it 'raises when after_date is later than before_date' do
      expect do
        described_class.validate_range!(aggregation: 'month', after_date: Date.new(2026, 6, 1),
                                        before_date: Date.new(2026, 1, 1))
      end.to raise_error(GraphQL::ExecutionError, /after_date must not be later/)
    end

    it 'does not raise for a valid range' do
      expect do
        described_class.validate_range!(aggregation: 'day', after_date: Date.new(2026, 8, 1),
                                        before_date: Date.new(2026, 8, 7))
      end.not_to raise_error
    end
  end
end
