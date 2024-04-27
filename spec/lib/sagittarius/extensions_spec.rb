# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/sagittarius/extensions'

RSpec.describe Sagittarius::Extensions do
  def stub_ee_exist(value)
    root = instance_double(Pathname)
    ee_extension_dir = instance_double(Pathname)
    allow(described_class).to receive(:root).and_return(root)
    allow(root).to receive(:join).and_return(ee_extension_dir)
    allow(ee_extension_dir).to receive(:exist?).and_return(value)
  end

  def stub_ee_disabled(value)
    allow(ENV).to receive(:fetch).with('SAGITTARIUS_DISABLE_EE', 'false').and_return(value)
  end

  describe '.active' do
    context 'when ee exists' do
      it do
        stub_ee_exist(true)
        stub_ee_disabled(false)
        expect(described_class.active).to include(:ee)
      end

      context 'when disabled with env' do
        it do
          stub_ee_exist(true)
          stub_ee_disabled(true)

          expect(described_class.active).not_to include(:ee)
        end
      end
    end

    context 'when ee does not exist' do
      it do
        stub_ee_exist(false)
        stub_ee_disabled(false)
        expect(described_class.active).not_to include(:ee)
      end
    end
  end

  describe '.ee?' do
    it 'returns true when ee exists' do
      stub_ee_exist(true)
      stub_ee_disabled(false)
      expect(described_class.ee?).to be(true)
    end

    it 'returns false when ee does not exist' do
      stub_ee_exist(false)
      stub_ee_disabled(false)
      expect(described_class.ee?).to be(false)
    end
  end

  describe '.ee' do
    it 'yields when ee exists' do
      stub_ee_exist(true)
      stub_ee_disabled(false)
      expect { |block| described_class.ee(&block) }.to yield_control
    end

    it 'does not yield when ee does not exist' do
      stub_ee_exist(false)
      stub_ee_disabled(false)
      expect { |block| described_class.ee(&block) }.not_to yield_control
    end
  end
end
