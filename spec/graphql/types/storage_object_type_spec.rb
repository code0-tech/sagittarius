# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::StorageObjectType do
  let(:fields) do
    %w[
      id
      project
      namespace
      file_name
      content_type
      byte_size
      checksum
      status
      origin
      expires_at
      download_url
      user_abilities
      created_at
      updated_at
    ]
  end

  it { expect(described_class.graphql_name).to eq('StorageObject') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_storage_object) }
end
