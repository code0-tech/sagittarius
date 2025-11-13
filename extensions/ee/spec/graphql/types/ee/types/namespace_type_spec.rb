# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Namespace'] do
  let(:fields) do
    %w[
      id
      parent
      members
      roles
      runtimes
      projects
      createdAt
      updatedAt
      namespaceLicenses
      currentNamespaceLicense
      userAbilities
    ]
  end

  it { expect(described_class).to include_module(EE::Types::NamespaceType) }
  it { expect(described_class).to have_graphql_fields(fields) }
end
