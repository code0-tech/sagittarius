# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Runtimes::CheckRuntimeCompatibilityService do
  subject(:service_response) do
    described_class.new(runtime, project).execute
  end

  let(:primary_runtime) { create(:runtime) }
  let(:runtime) { create(:runtime) }
  let(:project) { create(:namespace_project, primary_runtime: primary_runtime) }

  context 'when primary runtime is missing' do
    let(:project) { create(:namespace_project) }

    it 'returns an error with :missing_primary_runtime payload' do
      expect(service_response).to be_error
      expect(service_response.payload[:error_code]).to eq(:missing_primary_runtime)
    end
  end

  context 'when a model has fewer types on the runtime than on the primary' do
    before do
      create(:data_type, runtime: primary_runtime)
    end

    it 'returns missing_datatypes error' do
      expect(service_response.error?).to be true
      expect(service_response.payload[:error_code]).to eq(:missing_definition)
    end
  end

  context 'when secondary runtime has outdated definitions' do
    before do
      create(:data_type, runtime: primary_runtime, identifier: 'dt1', version: '1.3.0')
      create(:data_type, runtime: runtime, identifier: 'dt1', version: '1.2.0')
    end

    it 'returns outdated_data_type error' do
      expect(service_response.error?).to be true
      expect(service_response.payload[:error_code]).to eq(:outdated_definition)
    end
  end

  context 'when all models are compatible' do
    before do
      primary_module = create(:runtime_module, runtime: primary_runtime, version: '1.0.0')
      secondary_module = create(
        :runtime_module,
        runtime: runtime,
        identifier: primary_module.identifier,
        version: '1.0.0'
      )
      create(:data_type, runtime: primary_runtime, runtime_module: primary_module, identifier: 'dt1', version: '1.3.0')
      create(:data_type, runtime: runtime, runtime_module: secondary_module, identifier: 'dt1', version: '1.3.0')
      primary_runtime_flow_type = create(
        :runtime_flow_type,
        runtime: primary_runtime,
        runtime_module: primary_module,
        identifier: 'rft1',
        version: '2.1.0'
      )
      runtime_flow_type = create(
        :runtime_flow_type,
        runtime: runtime,
        runtime_module: secondary_module,
        identifier: 'rft1',
        version: '2.2.0'
      )
      create(:flow_type,
             runtime: primary_runtime,
             runtime_module: primary_module,
             runtime_flow_type: primary_runtime_flow_type,
             identifier: 'ft1',
             version: '2.1.0')
      create(:flow_type,
             runtime: runtime,
             runtime_module: secondary_module,
             runtime_flow_type: runtime_flow_type,
             identifier: 'ft1',
             version: '2.2.0')
      primary_rfd = create(
        :runtime_function_definition,
        runtime_name: 'rfd1',
        runtime: primary_runtime,
        runtime_module: primary_module,
        version: '3.0.0'
      )
      secondary_rfd = create(
        :runtime_function_definition,
        runtime_name: 'rfd1',
        runtime: runtime,
        runtime_module: secondary_module,
        version: '3.1.0'
      )
      create(
        :function_definition,
        runtime_function_definition: primary_rfd,
        identifier: 'fd1',
        runtime: primary_runtime,
        runtime_module: primary_module
      )
      create(
        :function_definition,
        runtime_function_definition: secondary_rfd,
        identifier: 'fd1',
        runtime: runtime,
        runtime_module: secondary_module
      )
    end

    it 'returns success with the runtime as payload' do
      expect(service_response).to be_success
      expect(service_response.payload).to eq(runtime)
    end
  end
end
