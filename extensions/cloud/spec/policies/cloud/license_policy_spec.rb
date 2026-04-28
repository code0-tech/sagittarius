# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LicensePolicy do
  it { expect(described_class).to include_module(CLOUD::LicensePolicy) }
end
