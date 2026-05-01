# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GlobalPolicy do
  it { expect(described_class).to include_module(EE::GlobalPolicy) }
end
