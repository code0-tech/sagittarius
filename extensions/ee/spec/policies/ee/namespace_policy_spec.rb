# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespacePolicy do
  it { expect(described_class).to include_module(EE::NamespacePolicy) }
end
