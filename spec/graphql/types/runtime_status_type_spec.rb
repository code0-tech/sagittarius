# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['RuntimeStatus'] do
  it { expect(described_class.graphql_name).to eq('RuntimeStatus') }

  it 'includes all concrete runtime status objects' do
    expect(described_class.possible_types).to include(
      Types::ActionStatusType,
      Types::AdapterRuntimeStatusType,
      Types::ExecutionRuntimeStatusType
    )
  end
end
