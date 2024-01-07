# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/sagittarius/utils'

RSpec.describe Sagittarius::Utils do
  describe '.to_boolean' do
    it 'accepts booleans' do
      expect(described_class.to_boolean(true)).to be(true)
      expect(described_class.to_boolean(false)).to be(false)
    end

    it 'converts a valid value to a boolean' do
      expect(described_class.to_boolean(true)).to be(true)
      expect(described_class.to_boolean('true')).to be(true)
      expect(described_class.to_boolean('YeS')).to be(true)
      expect(described_class.to_boolean('t')).to be(true)
      expect(described_class.to_boolean('1')).to be(true)
      expect(described_class.to_boolean(1)).to be(true)
      expect(described_class.to_boolean('ON')).to be(true)

      expect(described_class.to_boolean('FaLse')).to be(false)
      expect(described_class.to_boolean('F')).to be(false)
      expect(described_class.to_boolean('NO')).to be(false)
      expect(described_class.to_boolean('n')).to be(false)
      expect(described_class.to_boolean('0')).to be(false)
      expect(described_class.to_boolean(0)).to be(false)
      expect(described_class.to_boolean('oFF')).to be(false)
    end

    it 'converts an invalid value to nil' do
      expect(described_class.to_boolean('fals')).to be_nil
      expect(described_class.to_boolean('yeah')).to be_nil
      expect(described_class.to_boolean('')).to be_nil
      expect(described_class.to_boolean(nil)).to be_nil
    end

    it 'accepts a default value, and does not return it when a valid value is given' do
      expect(described_class.to_boolean(true, default: false)).to be(true)
      expect(described_class.to_boolean('true', default: false)).to be(true)
      expect(described_class.to_boolean('YeS', default: false)).to be(true)
      expect(described_class.to_boolean('t', default: false)).to be(true)
      expect(described_class.to_boolean('1', default: 'any value')).to be(true)
      expect(described_class.to_boolean('ON', default: 42)).to be(true)

      expect(described_class.to_boolean('FaLse', default: true)).to be(false)
      expect(described_class.to_boolean('F', default: true)).to be(false)
      expect(described_class.to_boolean('NO', default: true)).to be(false)
      expect(described_class.to_boolean('n', default: true)).to be(false)
      expect(described_class.to_boolean('0', default: 'any value')).to be(false)
      expect(described_class.to_boolean('oFF', default: 42)).to be(false)
    end

    it 'accepts a default value, and returns it when an invalid value is given' do
      expect(described_class.to_boolean('fals', default: true)).to be(true)
      expect(described_class.to_boolean('yeah', default: false)).to be(false)
      expect(described_class.to_boolean('', default: 'any value')).to eq('any value')
      expect(described_class.to_boolean(nil, default: 42)).to eq(42)
    end
  end
end
