# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::DateType do
  it 'coerces input from ISO 8601 dates' do
    expect(described_class.coerce_input('2026-05-12', nil)).to eq(Date.new(2026, 5, 12))
  end

  it 'coerces results to ISO 8601 dates' do
    expect(described_class.coerce_result(Date.new(2026, 5, 12), nil)).to eq('2026-05-12')
  end
end
