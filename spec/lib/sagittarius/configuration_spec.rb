# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sagittarius::Configuration do
  describe '.config' do
    let(:default_config_file) { Rails.root.join('config/sagittarius.yml') }

    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with('SAGITTARIUS_CONFIG_FILES', nil).and_return(nil)
      described_class.clear_memoize(:config)
    end

    it 'loads the default config file' do
      allow(YAML).to receive(:safe_load_file).with(default_config_file, fallback: {}).and_return(
        'rails' => {
          'web' => { 'threads' => 4 },
          'grpc' => { 'threads' => 8 },
        }
      )

      expect(described_class.config).to include(
        rails: a_hash_including(
          web: a_hash_including(threads: 4),
          grpc: a_hash_including(threads: 8)
        )
      )
    end

    it 'uses built-in defaults when the default config file does not exist' do
      allow(YAML).to receive(:safe_load_file).with(default_config_file, fallback: {}).and_raise(Errno::ENOENT)

      expect(described_class.config).to eq(described_class.defaults)
    end

    context 'when SAGITTARIUS_CONFIG_FILES contains multiple paths' do
      before do
        configured_files = ' config/base.yml,config/environment.yml, config/runtime.yml '
        allow(ENV).to receive(:fetch).with('SAGITTARIUS_CONFIG_FILES', nil)
                                     .and_return(configured_files)
        allow(YAML).to receive(:safe_load_file).with('config/base.yml', fallback: {}).and_return(
          'rails' => {
            'web' => { 'threads' => 4, 'port' => 4000 },
            'grpc' => { 'threads' => 4 },
          }
        )
        allow(YAML).to receive(:safe_load_file).with('config/environment.yml', fallback: {}).and_return(
          'rails' => {
            'web' => { 'threads' => 8 },
            'grpc' => { 'host' => 'environment:50051' },
          }
        )
        allow(YAML).to receive(:safe_load_file).with('config/runtime.yml', fallback: {}).and_return(
          'rails' => {
            'web' => { 'threads' => 16 },
          }
        )
      end

      it 'deep merges files in order with the last file taking precedence' do
        expect(described_class.config).to include(
          rails: a_hash_including(
            web: a_hash_including(threads: 16, port: 4000),
            grpc: a_hash_including(threads: 4, host: 'environment:50051')
          )
        )
      end

      it 'loads each configured file in order' do
        described_class.config

        expect(YAML).to have_received(:safe_load_file).ordered.with('config/base.yml', fallback: {})
        expect(YAML).to have_received(:safe_load_file).ordered.with('config/environment.yml', fallback: {})
        expect(YAML).to have_received(:safe_load_file).ordered.with('config/runtime.yml', fallback: {})
      end

      it 'raises when a configured file does not exist' do
        allow(YAML).to receive(:safe_load_file).with('config/environment.yml', fallback: {}).and_raise(Errno::ENOENT)

        expect { described_class.config }.to raise_error(Errno::ENOENT)
      end
    end
  end

  describe '.defaults' do
    it 'matches the example config' do
      example_config = YAML.safe_load_file(
        Rails.root.join('config/sagittarius.example.yml'),
        fallback: {}
      ).deep_symbolize_keys
      expect(example_config).to eq(described_class.defaults)
    end
  end
end
