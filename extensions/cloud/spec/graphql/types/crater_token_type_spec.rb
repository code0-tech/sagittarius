# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['CraterToken'] do
  let(:fields) { %w[user token] }

  it { expect(described_class.graphql_name).to eq('CraterToken') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
