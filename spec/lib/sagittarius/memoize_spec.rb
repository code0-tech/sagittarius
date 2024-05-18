# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/sagittarius/memoize'

RSpec.describe Sagittarius::Memoize do
  let(:impl_class) do
    Class.new do
      include Sagittarius::Memoize

      def memoized(block)
        memoize(:memoized, &block)
      end

      def memoize_with_change(change_value, block)
        memoize(:memoize_with_change, reset_on_change: -> { change_value }, &block)
      end
    end
  end

  let(:instance) { impl_class.new }

  it 'yields once' do
    expect { |b| instance.memoized(b) }.to yield_control
    expect { |b| instance.memoized(b) }.not_to yield_control
  end

  it 'allows memoize reset' do
    expect { |b| instance.memoized(b) }.to yield_control
    expect { |b| instance.memoized(b) }.not_to yield_control

    instance.clear_memoize(:memoized)

    expect { |b| instance.memoized(b) }.to yield_control
    expect { |b| instance.memoized(b) }.not_to yield_control
  end

  it 'allows memoize check' do
    expect(instance.memoized?(:memoized)).to be false

    instance.memoized(-> {})

    expect(instance.memoized?(:memoized)).to be true
  end

  it 'returns correct values' do
    expect(instance.memoized(-> { 1 })).to eq 1
    expect(instance.memoized(-> { 2 })).to eq 1 # 1 is due to memoization of first call
  end

  context 'with reset_on_change' do
    it 'memoizes when value is not changing' do
      expect { |b| instance.memoize_with_change(1, b) }.to yield_control
      expect { |b| instance.memoize_with_change(1, b) }.not_to yield_control
    end

    it 'does not memoize when value is changing' do
      expect { |b| instance.memoize_with_change(1, b) }.to yield_control
      expect { |b| instance.memoize_with_change(2, b) }.to yield_control
    end

    it 'clears old memoize when value changed' do
      expect { |b| instance.memoize_with_change(1, b) }.to yield_control
      expect { |b| instance.memoize_with_change(1, b) }.not_to yield_control

      expect { |b| instance.memoize_with_change(2, b) }.to yield_control
      expect { |b| instance.memoize_with_change(2, b) }.not_to yield_control

      expect { |b| instance.memoize_with_change(1, b) }.to yield_control
    end

    it 'returns correct values' do
      expect(instance.memoize_with_change(1, -> { 1 })).to eq 1
      expect(instance.memoize_with_change(2, -> { 2 })).to eq 2
    end
  end
end
