# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Runtimes::Grpc::DataTypeHelper do
  subject(:helper) { host_class.new(runtime) }

  let(:runtime) { create(:runtime) }
  let(:runtime_flow_type) { create(:runtime_flow_type, runtime: runtime) }
  let(:data_type_a) { create(:data_type, runtime: runtime) }
  let(:data_type_b) { create(:data_type, runtime: runtime) }
  let(:data_type_c) { create(:data_type, runtime: runtime) }

  let(:host_class) do
    Class.new do
      include Sagittarius::Database::Transactional
      include Runtimes::Grpc::DataTypeHelper

      attr_reader :current_runtime

      def initialize(current_runtime)
        @current_runtime = current_runtime
      end

      def link(record, identifiers)
        transactional do |t|
          link_data_types(record, identifiers, t)
          ServiceResponse.success(message: 'linked', payload: record)
        end
      end
    end
  end

  def linked_identifiers
    runtime_flow_type.reload.referenced_data_types.pluck(:identifier)
  end

  it 'creates links for the given identifiers' do
    response = helper.link(runtime_flow_type, [data_type_a.identifier, data_type_b.identifier])

    expect(response).to be_success
    expect(linked_identifiers).to contain_exactly(data_type_a.identifier, data_type_b.identifier)
  end

  it 'reorders an overlapping set without violating the unique index' do
    create(:runtime_flow_type_data_type_link, runtime_flow_type: runtime_flow_type,
                                              referenced_data_type: data_type_a)
    create(:runtime_flow_type_data_type_link, runtime_flow_type: runtime_flow_type,
                                              referenced_data_type: data_type_b)

    # Same set, swapped order: this used to raise PG::UniqueViolation via positional reuse.
    response = helper.link(runtime_flow_type, [data_type_b.identifier, data_type_a.identifier])

    expect(response).to be_success
    expect(linked_identifiers).to contain_exactly(data_type_a.identifier, data_type_b.identifier)
  end

  it 'adds new and removes stale links' do
    create(:runtime_flow_type_data_type_link, runtime_flow_type: runtime_flow_type,
                                              referenced_data_type: data_type_a)
    create(:runtime_flow_type_data_type_link, runtime_flow_type: runtime_flow_type,
                                              referenced_data_type: data_type_b)

    response = helper.link(runtime_flow_type, [data_type_b.identifier, data_type_c.identifier])

    expect(response).to be_success
    expect(linked_identifiers).to contain_exactly(data_type_b.identifier, data_type_c.identifier)
  end

  it 'removes all links when given no identifiers' do
    create(:runtime_flow_type_data_type_link, runtime_flow_type: runtime_flow_type,
                                              referenced_data_type: data_type_a)

    response = helper.link(runtime_flow_type, [])

    expect(response).to be_success
    expect(linked_identifiers).to be_empty
  end

  it 'reuses existing links without creating duplicate rows' do
    create(:runtime_flow_type_data_type_link, runtime_flow_type: runtime_flow_type,
                                              referenced_data_type: data_type_a)

    expect do
      helper.link(runtime_flow_type, [data_type_a.identifier, data_type_b.identifier])
    end.to change { runtime_flow_type.runtime_flow_type_data_type_links.count }.from(1).to(2)
  end

  it 'rolls back when an identifier cannot be resolved' do
    response = helper.link(runtime_flow_type, ['does-not-exist'])

    expect(response).not_to be_success
    expect(response.payload[:error_code]).to eq(:no_data_type_for_identifier)
  end
end
