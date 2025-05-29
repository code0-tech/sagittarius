RSpec.shared_context 'mocked service class instances' do
  let(:service_instances) do
    mocked_service_expectations.keys.index_with do |klass|
      instance_double(klass, execute: default_execute_response)
    end
  end

  let(:default_execute_response) { ServiceResponse.success(payload: default_payload) }
  let(:default_payload) { nil }

  before do
    service_instances.each do |klass, instance|
      allow(klass).to receive(:new).with(any_args).and_return(instance)
    end
  end

  after do
    expect_service_calls
  end

  def expect_service_calls
    mocked_service_expectations.each do |klass, expectation|
      expect(service_instances[klass]).to have_received(:execute).exactly(expectation).times
    end
  end
end
