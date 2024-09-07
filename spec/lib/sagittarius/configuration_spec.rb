# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sagittarius::Configuration do
  describe '.config' do
    let(:yaml_config) do
      <<~CONFIG
        rails:
          threads: 4
      CONFIG
    end

    before do
      allow(File).to receive(:open).and_call_original
      allow(File).to receive(:open)
        .with(Rails.root.join('config/sagittarius.yml'), instance_of(String))
        .and_yield(yaml_config)
      described_class.clear_memoize(:config)
    end

    it 'loads the config' do
      expect(described_class.config).to include(rails: a_hash_including(threads: 4))
    end
  end

  describe '.defaults' do
    it 'matches the example config' do
      example_config = YAML.safe_load_file(Rails.root.join('config/sagittarius.example.yml')).deep_symbolize_keys
      expect(example_config).to eq(described_class.defaults)
    end
  end
end
