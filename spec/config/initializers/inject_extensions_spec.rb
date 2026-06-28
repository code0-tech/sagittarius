# frozen_string_literal: true

require 'spec_helper'
require 'support/matchers/module_matchers'

require_relative '../../../config/initializers/0_inject_extensions'
require_relative '../../../lib/sagittarius/extensions'
require_relative '../../../lib/sagittarius/utils'

RSpec.describe InjectExtensions do
  let(:extension_name) { 'FF' }
  let(:extension_namespace) { Module.new }
  let(:fish_name) { 'Fish' }
  let(:fish_class) { Class.new }
  let(:fish_extension) { Module.new }

  before do
    # Make sure we're not relying on which mode we're running under
    allow(Sagittarius::Extensions).to receive(:active).and_return([extension_name.downcase])

    # Test on an imagined extension and imagined class
    stub_const(fish_name, fish_class) # Fish
    allow(fish_class).to receive(:name).and_return(fish_name)
  end

  shared_examples 'expand the assumed extension with' do |method|
    context 'when extension namespace is set at top-level' do
      before do
        stub_const(extension_name, extension_namespace) # FF
        extension_namespace.const_set(fish_name, fish_extension) # FF::Fish
      end

      it "calls #{method} with the extension module" do
        allow(fish_class).to receive(method)
        fish_class.send("#{method}_extensions")
        expect(fish_class).to have_received(method).with(fish_extension)
      end

      it 'includes the extension module' do
        fish_class.send("#{method}_extensions")
        expect(fish_class).to include_module(fish_extension)
      end
    end

    context 'when extension namespace exists but not the extension' do
      before do
        stub_const(extension_name, extension_namespace) # FF
      end

      it "does not call #{method}" do
        allow(fish_class).to receive(method)
        fish_class.send("#{method}_extensions")

        expect(fish_class).not_to have_received(method).with(fish_extension)
      end

      it 'does not include the extension module' do
        fish_class.send("#{method}_extensions")
        expect(fish_class).not_to include_module(fish_extension)
      end
    end

    context 'when extension namespace does not exist' do
      it "does not call #{method}" do
        allow(fish_class).to receive(method)
        fish_class.send("#{method}_extensions")

        expect(fish_class).not_to have_received(method).with(fish_extension)
      end

      it 'does not include the extension module' do
        fish_class.send("#{method}_extensions")
        expect(fish_class).not_to include_module(fish_extension)
      end
    end
  end

  describe '#prepend_extensions' do
    it_behaves_like 'expand the assumed extension with', :prepend
  end

  describe Module do
    it { is_expected.to include_module(InjectExtensions) }
  end
end
