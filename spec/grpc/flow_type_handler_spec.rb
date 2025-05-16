# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowTypeHandler do
  subject(:handler) { described_class.new }

  it { is_expected.to respond_to(:update) }
end
