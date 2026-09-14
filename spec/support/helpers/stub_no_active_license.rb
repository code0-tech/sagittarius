# frozen_string_literal: true

# no_active_license? is defined via prepended modules (EE::FlowHandler, CLOUD::FlowHandler),
# which always win over a plain `allow(...).to receive(...)` stub, so this stubs via a real
# prepend instead. Installed once and reused, falling back to the real chain via `super` and
# resetting after each example, so nothing leaks across spec files.
module StubNoActiveLicense
  module FlowHandlerStub
    class << self
      attr_accessor :value
    end

    def no_active_license?
      return FlowHandlerStub.value unless FlowHandlerStub.value.nil?

      super
    end
  end

  def stub_no_active_license(value)
    FlowHandler.singleton_class.prepend(FlowHandlerStub) unless FlowHandler.singleton_class <= FlowHandlerStub

    FlowHandlerStub.value = value
  end
end

RSpec.configure do |config|
  config.include StubNoActiveLicense

  config.after do
    StubNoActiveLicense::FlowHandlerStub.value = nil
  end
end
