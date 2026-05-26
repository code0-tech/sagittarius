# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController do
  it { expect(described_class).to include_module(CLOUD::ApplicationController) }
end
