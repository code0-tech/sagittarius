# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sagittarius::Context do
  describe '.with_context' do
    it 'builds a context with values from the previous one' do
      inner = nil
      outer = nil

      described_class.with_context(described_class::CORRELATION_ID_KEY => 'hello') do |outer_context|
        outer = outer_context
        described_class.with_context(user: 'username') do |inner_context|
          inner = inner_context
        end
      end

      expect(data_from(outer)).to eq(log_hash(described_class::CORRELATION_ID_KEY => 'hello'))
      expect(data_from(inner)).to eq(log_hash(described_class::CORRELATION_ID_KEY => 'hello', 'user' => 'username'))
    end

    it 'builds a context with overwritten key/values in the newer context' do
      inner = nil
      outer = nil

      described_class.with_context(caller_id: 'foo') do |outer_context|
        outer = outer_context
        described_class.with_context(caller_id: 'bar') do |inner_context|
          inner = inner_context
        end
      end

      expect(data_from(outer)).to include(log_hash(caller_id: 'foo'))
      expect(data_from(inner)).to include(log_hash(caller_id: 'bar'))
    end

    it 'yields the block' do
      expect { |b| described_class.with_context(&b) }.to yield_control
    end

    it "pushes the context on the stack while it's running" do
      described_class.with_context do |outer|
        described_class.with_context do |inner|
          expect(contexts).to eq([outer, inner])
        end
      end
    end

    it 'pops the context from the stack when the block fails' do
      expect { described_class.with_context { |_| raise('broken') } }.to raise_error('broken')

      expect(contexts).to be_empty
    end

    it 'returns the value from the block' do
      expect(described_class.with_context { |_| 'some random string' }).to eq('some random string')
    end
  end

  describe '.push' do
    let!(:root_context) { described_class.push }

    after do
      described_class.pop(root_context)
    end

    it 'pushes a new context on the stack' do
      context = described_class.push

      expect(contexts).to eq([root_context, context])
    end

    it 'merges the attributes of the context with the previous one' do
      expected_values = { described_class::CORRELATION_ID_KEY => root_context.correlation_id,
                          'root_namespace' => 'namespace' }

      context = described_class.push(root_namespace: 'namespace')

      expect(data_from(context)).to eq(log_hash(expected_values))
    end
  end

  describe '.pop' do
    let!(:root_context) { described_class.push }

    after do
      described_class.pop(root_context)
    end

    it 'pops all context up to and including the given one' do
      second_context = described_class.push
      _third_context = described_class.push

      described_class.pop(second_context)

      expect(contexts).to contain_exactly(root_context)
    end
  end

  describe '.current' do
    let!(:root_context) { described_class.push }

    after do
      described_class.pop(root_context)
    end

    it 'returns the last context' do
      expect(described_class.current).to eq(root_context)

      new_context = described_class.push

      expect(described_class.current).to eq(new_context)
    end
  end

  describe '#to_h' do
    let(:expected_hash) do
      log_hash(user: 'user',
               root_namespace: 'namespace',
               project: 'project',
               'random.key': 'included')
    end

    it 'returns a hash containing the expected values' do
      context = described_class.new(user: 'user',
                                    project: 'project',
                                    root_namespace: 'namespace',
                                    'random.key': 'included')

      expect(context.to_h).to include(expected_hash)
    end

    it 'returns a new hash every call' do
      context = described_class.new

      expect(context.to_h.object_id).not_to eq(context.to_h.object_id)
    end

    it 'loads the lazy values' do
      context = described_class.new(
        user: -> { 'user' },
        root_namespace: -> { 'namespace' },
        project: -> { 'project' },
        'random.key': -> { 'included' }
      )

      expect(context.to_h).to include(expected_hash)
    end

    it 'does not change the original data' do
      context = described_class.new(
        user: -> { 'user' },
        root_namespace: -> { 'namespace' },
        project: -> { 'project' }
      )

      expect { context.to_h }.not_to(change { data_from(context) })
    end

    it 'does not include empty values' do
      context = described_class.new(
        user: -> {},
        root_namespace: nil,
        project: ''
      )

      expect(context.to_h.keys).to contain_exactly(described_class::CORRELATION_ID_KEY)
    end
  end

  describe '#initialize' do
    it 'assigns all keys as strings' do
      context = described_class.new( # -- deliberately testing asigning symbols and strings as keys
        user: 'u',
        'project' => 'p',
        something_else: 'nothing'
      )

      expect(data_from(context)).to include(log_hash('user' => 'u', 'project' => 'p', 'something_else' => 'nothing'))
    end

    it 'assigns known keys starting with the log key' do
      context = described_class.new(
        log_hash(project: 'p', root_namespace: 'n', user: 'u', something_else: 'nothing')
      )

      expect(data_from(context)).to include(log_hash('project' => 'p', 'root_namespace' => 'n', 'user' => 'u',
                                                     'something_else' => 'nothing'))
    end

    it 'always assigns a correlation id' do
      expect(described_class.new.correlation_id).not_to be_empty
    end
  end

  describe '#merge' do
    it 'returns a new context with duplicated data' do
      context = described_class.new(user: 'user')

      new_context = context.merge({})

      expect(context.to_h).to eq(new_context.to_h)
      expect(context).not_to eq(new_context)
    end

    it 'merges values into the existing context' do
      context = described_class.new(project: 'p', root_namespace: 'n', user: 'u')

      new_context = context.merge(project: '', root_namespace: 'namespace')

      expect(data_from(new_context)).to include(log_hash('root_namespace' => 'namespace', 'user' => 'u'))
    end

    it 'removes empty values' do
      context = described_class.new(project: 'p', root_namespace: 'n', user: 'u')

      new_context = context.merge(project: '', user: nil)

      expect(data_from(new_context)).to include(log_hash('root_namespace' => 'n'))
      expect(data_from(new_context).keys).not_to include(described_class.log_key('project'),
                                                         described_class.log_key('user'))
    end

    it 'keeps false values' do
      context = described_class.new(project: 'p', root_namespace: 'n', flag: false)

      new_context = context.merge(project: '', false: nil) # rubocop:disable Lint/BooleanSymbol -- intended for this spec

      expect(data_from(new_context)).to include(log_hash('root_namespace' => 'n', 'flag' => false))
      expect(context.to_h).to include(log_hash('root_namespace' => 'n', 'flag' => false))
    end

    it 'does not overwrite the correlation id' do
      context = described_class.new(described_class::CORRELATION_ID_KEY => 'hello')

      new_context = context.merge(user: 'u')

      expect(new_context.correlation_id).to eq('hello')
    end

    it 'generates a new correlation id if a blank one was passed' do
      context = described_class.new
      old_correlation_id = context.correlation_id

      new_context = context.merge(described_class::CORRELATION_ID_KEY => '')

      expect(new_context.correlation_id).not_to be_empty
      expect(new_context.correlation_id).not_to eq(old_correlation_id)
    end
  end

  describe '#get_attribute' do
    using RSpec::Parameterized::TableSyntax

    where(:set_context, :attribute, :expected_value) do
      [
        [{}, :caller_id, nil],
        [{ caller_id: 'caller' }, :caller_id, 'caller'],
        [{ caller_id: -> { 'caller' } }, :caller_id, 'caller'],
        [{ caller_id: -> { 'caller' } }, 'caller_id', 'caller'],
        [{ caller_id: -> { 'caller' } }, 'meta.caller_id', 'caller']
      ]
    end

    with_them do
      it 'returns the expected value for the attribute' do
        described_class.with_context(set_context) do |context|
          expect(context.get_attribute(attribute)).to eq(expected_value)
        end
      end
    end
  end

  def contexts
    described_class.__send__(:contexts)
  end

  def data_from(context)
    context.__send__(:data)
  end

  def log_hash(hash)
    hash.transform_keys! { |key| described_class.log_key(key) }
  end
end
