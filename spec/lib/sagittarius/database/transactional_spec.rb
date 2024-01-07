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

    it 'can return and rollback' do
      user = nil
      expect(described_class.transactional do |helper|
        user = create(:user)
        expect { user.reload }.not_to raise_error
        helper.rollback_and_return!(1)
      end).to eq(1)

      expect { user.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
