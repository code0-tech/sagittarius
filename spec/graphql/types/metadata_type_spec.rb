# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::MetadataType do
  it { expect(described_class.graphql_name).to eq('Metadata') }
  it { expect(described_class).to have_graphql_fields(:version, :extensions) }

  describe 'fields' do
    subject(:field) { described_class.fields[field_name] }

    shared_examples 'metadata field' do |expected_type|
      it { expect(field.type).to eq(expected_type) }
    end

    describe 'version' do
      let(:field_name) { 'version' }

      it_behaves_like 'metadata field', 'String!'
    end

    describe 'extensions' do
      let(:field_name) { 'extensions' }

      it_behaves_like 'metadata field', '[String!]!'
    end
  end
end
