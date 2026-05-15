# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BasePolicy do
  it { expect(described_class).to include_module(CLOUD::BasePolicy) }
end
