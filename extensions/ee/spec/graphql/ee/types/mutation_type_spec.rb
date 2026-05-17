# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Mutation'] do
  it { expect(described_class).to include_module(EE::Types::MutationType) }
end
