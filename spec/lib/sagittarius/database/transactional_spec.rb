# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sagittarius::Database::Transactional do
  describe '.transactional' do
    it 'yields control' do
      expect { |b| described_class.transactional(&b) }.to yield_control
    end

    it 'passes return value from block' do
      expect(described_class.transactional { 1 }).to eq(1)
    end
  end
end
