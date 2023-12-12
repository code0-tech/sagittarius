# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sagittarius::Loggable do
  let(:clazz) do
    Class.new do
      include Sagittarius::Loggable
    end
  end

  context 'with named class' do
    around do |example|
      Object.const_set('TestClass', clazz)
      example.run
      Object.send(:remove_const, 'TestClass')
    end

    it 'for instantiated class' do
      TestClass.new.logger.with_context do |context|
        expect(context.to_h).to include(Sagittarius::Context.log_key(:class) => 'TestClass')
      end
    end

    it 'when called on the class' do
      TestClass.logger.with_context do |context|
        expect(context.to_h).to include(Sagittarius::Context.log_key(:class) => 'TestClass')
      end
    end
  end

  context 'with anonymous class' do
    it 'for instantiated class' do
      clazz.new.logger.with_context do |context|
        expect(context.to_h).to include(Sagittarius::Context.log_key(:class) => '<Anonymous>')
      end
    end

    it 'when called on the class' do
      clazz.logger.with_context do |context|
        expect(context.to_h).to include(Sagittarius::Context.log_key(:class) => '<Anonymous>')
      end
    end
  end
end
