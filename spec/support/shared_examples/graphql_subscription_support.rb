# frozen_string_literal: true

RSpec.shared_context 'with graphql subscription support' do
  let(:stream_callbacks) { {} }
  let(:subscription_streams) { {} }

  before do
    callbacks = stream_callbacks
    sub_streams = subscription_streams
    test_spec = self

    ActionCable::Channel::ChannelStub.define_method(:stream_from) do |broadcasting, coder: nil, &block|
      streams << broadcasting
      if block
        callbacks[broadcasting] = { block: block, coder: coder }
      else
        sub_streams[broadcasting] = true
      end
    end

    pubsub = ActionCable.server.pubsub
    allow(pubsub).to receive(:broadcast).and_wrap_original do |method, stream, message|
      method.call(stream, message)
      if (cb = callbacks[stream])
        decoded = cb[:coder] ? cb[:coder].decode(message) : message
        cb[:block].call(decoded)
      elsif sub_streams[stream]
        decoded = ActiveSupport::JSON.decode(message)
        test_spec.subscription.send(:transmit, decoded)
      end
    end
  end

  after do
    ActionCable::Channel::ChannelStub.define_method(:stream_from) do |broadcasting, *|
      streams << broadcasting
    end
  end
end
